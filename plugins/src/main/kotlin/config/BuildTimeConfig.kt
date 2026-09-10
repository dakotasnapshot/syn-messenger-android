/*
 * Copyright (c) 2025 Element Creations Ltd.
 * Copyright 2025 New Vector Ltd.
 *
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
 * Please see LICENSE files in the repository root for full details.
 */

package config

object BuildTimeConfig {
    const val APPLICATION_ID = "app.syn.messenger"
    const val APPLICATION_NAME = "SYN Messenger"
    const val GOOGLE_APP_ID_RELEASE = "1:526902586678:android:206902e7eb917939821797"
    const val GOOGLE_APP_ID_DEBUG = "1:526902586678:android:6337bf3aa6c5dfec821797"
    const val GOOGLE_APP_ID_NIGHTLY = "1:526902586678:android:6337bf3aa6c5dfec821797"

    const val METADATA_HOST_REVERSED: String = "app.syn.messenger"
    const val URL_WEBSITE: String = "https://synmessenger.com"
    const val URL_LOGO: String = "https://synmessenger.com/logo.svg"
    const val URL_COPYRIGHT: String = "https://synmessenger.com/terms/"
    const val URL_ACCEPTABLE_USE: String = "https://synmessenger.com/terms/"
    const val URL_PRIVACY: String = "https://synmessenger.com/privacy/"
    const val URL_POLICY: String = "https://synmessenger.com/privacy/"
    val SERVICES_MAPTILER_BASE_URL: String? = null
    val SERVICES_MAPTILER_APIKEY: String? = null
    val SERVICES_MAPTILER_LIGHT_MAPID: String? = null
    val SERVICES_MAPTILER_DARK_MAPID: String? = null
    val SERVICES_POSTHOG_HOST: String? = null
    val SERVICES_POSTHOG_APIKEY: String? = null
    val SERVICES_SENTRY_DSN: String? = null
    val SERVICES_SENTRY_DSN_RUST: String? = null
    val BUG_REPORT_URL: String? = null
    val BUG_REPORT_APP_NAME: String? = null

    const val PUSH_CONFIG_INCLUDE_FIREBASE = true
    const val PUSH_CONFIG_INCLUDE_UNIFIED_PUSH = true
}
