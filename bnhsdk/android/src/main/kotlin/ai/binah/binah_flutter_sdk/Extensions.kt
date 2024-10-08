package ai.binah.binah_flutter_sdk

import ai.binah.sdk.api.SessionEnabledVitalSigns
import ai.binah.sdk.api.images.ImageData
import ai.binah.sdk.api.license.LicenseInfo
import ai.binah.sdk.api.alerts.AlertData
import ai.binah.sdk.api.vital_signs.VitalSign
import ai.binah.sdk.api.vital_signs.VitalSignConfidence
import ai.binah.sdk.api.vital_signs.vitals.*
import android.graphics.Bitmap
import android.graphics.Rect
import android.view.TextureView

fun TextureView.drawBitmap(bitmap: Bitmap) {
    lockCanvas()?.apply {
        drawBitmap(
            bitmap,
            null,
            Rect(0, 0, width, bottom - top),
            null
        )
        unlockCanvasAndPost(this)
    }
}


fun Rect.toMap(): Map<String, Int> {
    return mapOf(
        Pair("left", this.left),
        Pair("top", this.top),
        Pair("width", this.width()),
        Pair("height", this.height())
    )
}

fun ImageData.toMap(): Map<String, Any?> {
    return mapOf(
        Pair("width", image.width),
        Pair("height", image.height),
        Pair("roi", roi?.toMap()),
        Pair("validity", imageValidity)
    )
}

fun AlertData.toMap(): Map<String, Any> {
    return mapOf(
        Pair("domain", domain),
        Pair("code", code)
    )
}

fun LicenseInfo.toMap(): Map<String, Any> {
    val map = mutableMapOf<String, Any>(
        Pair("activation_id", licenseActivationInfo.activationID)
    )
    licenseOfflineMeasurements?.let { offlineMeasurements ->
        map["offline_measurements_total"] = offlineMeasurements.totalMeasurements
        map["offline_measurements_remaining"] = offlineMeasurements.remainingMeasurements
        map["offline_measurements_end_timestamp"] = offlineMeasurements.measurementEndTimestamp
    }

    return map
}

fun SessionEnabledVitalSigns.toMap(): Map<String, Long> {
    return mapOf(
        Pair("device_enabled", deviceEnabledVitalSigns.enabledVitalsSigns),
        Pair("measurement_mode_enabled", measurementModeEnabledVitalSigns.enabledVitalsSigns),
        Pair("license_enabled", licenseEnabledVitalSigns.enabledVitalsSigns)
    )
}

fun VitalSign.toMap(): Map<String, Any>? {
    var confidence: VitalSignConfidence? = null
    val resolvedValue = when (this) {
        is VitalSignPulseRate -> {
            confidence = this.confidence
            value
        }
        is VitalSignRespirationRate -> {
            confidence = this.confidence
            value
        }
        is VitalSignPRQ -> {
            confidence = this.confidence
            value
        }
        is VitalSignMeanRRI -> {
            confidence = this.confidence
            value
        }
        is VitalSignSDNN -> {
            confidence = this.confidence
            value
        }
        is VitalSignRRI -> {
            confidence = this.confidence
            if (value.isEmpty()) null else value.map { rriValue ->
                mapOf(
                    Pair("interval", rriValue.interval),
                    Pair("timestamp", rriValue.timestamp)
                )
            }
        }
        is VitalSignStressLevel -> value.ordinal
        is VitalSignPNSZone -> value.ordinal
        is VitalSignSNSZone -> value.ordinal
        is VitalSignWellnessLevel -> value.ordinal
        is VitalSignBloodPressure -> mapOf(
            Pair("systolic", value.systolic),
            Pair("diastolic", value.diastolic)
        )
        else -> value
    }

    return mutableMapOf(
        Pair("type", type),
        Pair("value", resolvedValue ?: return null)
    ).apply {
        if (confidence != null) {
            put("confidence", mapOf(Pair("level", confidence.level.ordinal)))
        }
    }
}