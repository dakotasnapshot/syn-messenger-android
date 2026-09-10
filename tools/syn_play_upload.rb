#!/usr/bin/env ruby
# Upload SYN Messenger's English Play listing and imagery using the Android Publisher API.

require "base64"
require "json"
require "net/http"
require "openssl"
require "uri"

PACKAGE = "app.syn.messenger"
LOCALE = "en-US"
ROOT = File.expand_path("..", __dir__)
METADATA = File.join(ROOT, "fastlane", "metadata", "android", LOCALE)
CREDENTIALS = File.expand_path(ENV.fetch("SYN_PLAY_CREDENTIALS", "~/.config/syn/google-play-service-account.json"))

def base64url(value)
  Base64.urlsafe_encode64(value).delete("=")
end

def access_token
  key = JSON.parse(File.read(CREDENTIALS))
  now = Time.now.to_i
  header = base64url(JSON.generate(alg: "RS256", typ: "JWT"))
  claims = base64url(JSON.generate(
    iss: key.fetch("client_email"),
    scope: "https://www.googleapis.com/auth/androidpublisher",
    aud: key.fetch("token_uri"),
    iat: now,
    exp: now + 3600
  ))
  unsigned = "#{header}.#{claims}"
  signature = OpenSSL::PKey::RSA.new(key.fetch("private_key")).sign(OpenSSL::Digest::SHA256.new, unsigned)
  assertion = "#{unsigned}.#{base64url(signature)}"
  uri = URI(key.fetch("token_uri"))
  req = Net::HTTP::Post.new(uri)
  req.set_form_data(
    "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer",
    "assertion" => assertion
  )
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 20, read_timeout: 30) { |http| http.request(req) }
  raise "Token request failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  JSON.parse(response.body).fetch("access_token")
end

def request(token, method, url, body: nil, content_type: "application/json")
  uri = URI(url)
  klass = { post: Net::HTTP::Post, put: Net::HTTP::Put, delete: Net::HTTP::Delete }.fetch(method)
  req = klass.new(uri)
  req["Authorization"] = "Bearer #{token}"
  req["Content-Type"] = content_type
  req.body = body if body
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 20, read_timeout: 60) { |http| http.request(req) }
  raise "#{method.upcase} #{uri.path} failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  response.body.empty? ? {} : JSON.parse(response.body)
end

token = access_token
base = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/#{PACKAGE}"
edit = request(token, :post, "#{base}/edits", body: "{}").fetch("id")

listing = {
  language: LOCALE,
  title: File.read(File.join(METADATA, "title.txt")).strip,
  shortDescription: File.read(File.join(METADATA, "short_description.txt")).strip,
  fullDescription: File.read(File.join(METADATA, "full_description.txt")).strip,
  video: ""
}
request(token, :put, "#{base}/edits/#{edit}/listings/#{LOCALE}", body: JSON.generate(listing))

images = File.join(METADATA, "images")
uploads = {
  "icon" => [File.join(images, "icon.png")],
  "featureGraphic" => [File.join(images, "featureGraphic.png")],
  "phoneScreenshots" => Dir[File.join(images, "phoneScreenshots", "*.png")].sort
}

uploads.each do |type, paths|
  request(token, :delete, "#{base}/edits/#{edit}/listings/#{LOCALE}/#{type}")
  paths.each do |path|
    upload_url = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/#{PACKAGE}/edits/#{edit}/listings/#{LOCALE}/#{type}?uploadType=media"
    request(token, :post, upload_url, body: File.binread(path), content_type: "image/png")
  end
end

request(token, :post, "#{base}/edits/#{edit}:commit", body: "{}")
puts "Uploaded #{listing[:title]} listing: #{uploads.values.flatten.length} images"
