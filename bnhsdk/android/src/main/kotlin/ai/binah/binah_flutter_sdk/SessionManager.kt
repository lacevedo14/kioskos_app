package ai.binah.binah_flutter_sdk

import ai.binah.sdk.api.HealthMonitorException
import ai.binah.sdk.api.SessionEnabledVitalSigns
import ai.binah.sdk.api.images.DeviceOrientation
import ai.binah.sdk.api.images.ImageData
import ai.binah.sdk.api.images.ImageListener
import ai.binah.sdk.api.license.LicenseDetails
import ai.binah.sdk.api.license.LicenseInfo
import ai.binah.sdk.api.session.Session
import ai.binah.sdk.api.session.SessionInfoListener
import ai.binah.sdk.api.session.SessionState
import ai.binah.sdk.api.alerts.ErrorData
import ai.binah.sdk.api.alerts.WarningData
import ai.binah.sdk.api.session.demographics.Sex
import ai.binah.sdk.api.session.demographics.SubjectDemographic
import ai.binah.sdk.api.vital_signs.VitalSign
import ai.binah.sdk.api.vital_signs.VitalSignsListener
import ai.binah.sdk.api.vital_signs.VitalSignsResults
import ai.binah.sdk.session.FaceSessionBuilder
import ai.binah.sdk.session.FingerSessionBuilder
import ai.binah.sdk.session.MeasurementMode
import android.content.Context
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow

object SessionManager: ImageDataSource, ImageListener, VitalSignsListener, SessionInfoListener {

    private val _images = MutableSharedFlow<ImageData>(replay = 0, extraBufferCapacity = 1, onBufferOverflow = BufferOverflow.DROP_LATEST)
    private var session: Session? = null

    override val images: Flow<ImageData> = _images

    var eventChannel: BinahEventChannel? = null

    @Throws(HealthMonitorException::class)
    fun createSession(
        context: Context,
        licenseKey: String,
        productId: String? = null,
        measurementMode: Int?,
        deviceOrientation: Int? = null,
        subjectSex: Int? = null,
        subjectAge: Double? = null,
        subjectWeight: Double? = null,
        detectionAlwaysOn: Boolean? = false,
        options: Map<String, Any>? = null
    ) {
        val mode = resolveMeasurementMode(measurementMode)
        val sessionBuilder = if (mode == MeasurementMode.FACE) {
            val orientation = resolveDeviceOrientation(deviceOrientation)
            val subjectDemographic = resolveSubjectDemographic(
                subjectSex,
                subjectAge,
                subjectWeight
            )

            FaceSessionBuilder(context)
                .withDeviceOrientation(orientation)
                .withSubjectDemographic(subjectDemographic)
                .withDetectionAlwaysOn(detectionAlwaysOn ?: false)
        } else {
            FingerSessionBuilder(context)
        }

        session = sessionBuilder
            .withImageListener(this@SessionManager)
            .withVitalSignsListener(this@SessionManager)
            .withSessionInfoListener(this@SessionManager)
            .withOptions(options)
            .build(LicenseDetails(licenseKey, productId))
    }

    @Throws(HealthMonitorException::class)
    fun startSession(duration: Int?) {
        session?.start(duration?.toLong() ?: 0)
    }

    @Throws(HealthMonitorException::class)
    fun stopSession() {
        session?.stop()
    }

    fun terminateSession() {
        session?.terminate()
    }

    fun getSessionState(): SessionState? {
        return session?.state
    }

    override fun onVitalSign(vitalSign: VitalSign) {
        eventChannel?.sendEvent(NativeBridgeEvents.sessionVitalSign, vitalSign.toMap() ?: return)
    }

    override fun onFinalResults(vitalSignsResults: VitalSignsResults) {
        val results = vitalSignsResults.results.mapNotNull { result ->
            result.toMap()
        }
        eventChannel?.sendEvent(NativeBridgeEvents.sessionFinalResults, results)
    }

    override fun onImage(imageData: ImageData) {
        eventChannel?.sendEvent(NativeBridgeEvents.imageData, imageData.toMap())
        _images.tryEmit(imageData)
    }

    override fun onSessionStateChange(sessionState: SessionState) {
        eventChannel?.sendEvent(NativeBridgeEvents.sessionStateChange, sessionState.ordinal)
    }

    override fun onWarning(warningData: WarningData) {
        eventChannel?.sendEvent(NativeBridgeEvents.sessionWarning, warningData.toMap())
    }

    override fun onError(errorData: ErrorData) {
        eventChannel?.sendEvent(NativeBridgeEvents.sessionError, errorData.toMap())
    }

    override fun onLicenseInfo(licenseInfo: LicenseInfo) {
        eventChannel?.sendEvent(NativeBridgeEvents.licenseInfo, licenseInfo.toMap())
    }

    override fun onEnabledVitalSigns(enabledVitalSigns: SessionEnabledVitalSigns) {
        eventChannel?.sendEvent(NativeBridgeEvents.enabledVitalSigns, enabledVitalSigns.toMap())
    }

    private fun resolveMeasurementMode(measurementMode: Int?): MeasurementMode {
        if (measurementMode == MeasurementMode.FINGER.ordinal) {
            return MeasurementMode.FINGER
        }

        return MeasurementMode.FACE
    }

    private fun resolveDeviceOrientation(deviceOrientation: Int?): DeviceOrientation? {
        return deviceOrientation?.let {orientation ->
            try {
                DeviceOrientation.values()[orientation]
            } catch (ignore: IndexOutOfBoundsException) {
                null
            }
        }
    }

    private fun resolveSubjectDemographic(sexInt: Int?, age: Double?, weight: Double?): SubjectDemographic {
        val sex = sexInt?.let { sex ->
            try {
                Sex.values()[sex]
            } catch (e: IndexOutOfBoundsException) {
                Sex.UNSPECIFIED
            }
        }

        return SubjectDemographic(sex, age, weight)
    }
}