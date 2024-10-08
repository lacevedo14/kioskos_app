
import Foundation
import Combine

class SessionManager: ImageDataSource, ImageListener, VitalSignsListener, SessionInfoListener {
    
    static let shared = SessionManager()
    
    var eventChannel: BinahEventChannel?
        private var session: Session?
    
    let images = PassthroughSubject<ImageData, Never>()
    
    private init() {}
    
    func createSession(
        licenseKey: String,
        productId: String? = nil,
        measurementMode: Int?,
        deviceOrientation: Int? = nil,
        subjectSex: Int? = nil,
        subjectAge: Double? = nil,
        subjectWeight: Double? = nil,
        detectionAlwaysOn: Bool? = false,
        imageFormatMode: Int? = nil,
        options: [String: Any]? = nil
    
    ) throws {
        let mode = resolveMeasurementMode(measurementMode: measurementMode)
        var sessionBuilder: SessionBuilder
        if (mode == MeasurementMode.face) {
            var builder = FaceSessionBuilder()
            if let subjectDemographic = resolveSubjectDemographic(sex: subjectSex, age: subjectAge, weight: subjectWeight) {
                builder = builder.withSubjectDemographic(subjectDemographic)
            }
            
            if let orientation = resolveDeviceOrientation(deviceOrientation: deviceOrientation) {
                builder = builder.withDeviceOrientation(orientation)
            }

            if let imageFormat = resolveImageFormat(imageFormatMode: imageFormatMode) {
                builder = builder.withImageFormatMode(imageFormat)
            }

            builder = builder.withDetectionAlwaysOn(detectionAlwaysOn ?? false)
            sessionBuilder = builder
        } else {
            sessionBuilder = FingerSessionBuilder()
        }

        session = try sessionBuilder
            .withImageListener(self)
            .withVitalSignsListener(self)
            .withSessionInfoListener(self)
            .withOptions(options: options ?? [:])
            .build(licenseDetails: LicenseDetails(licenseKey: licenseKey, productId: productId))
    }
    
    
    func startSession(duration: Int?) throws {
        try session?.start(measurementDuration: UInt64(duration ?? 0))
    }

    func stopSession() throws {
        try session?.stop()
    }

    func terminateSession() {
        session?.terminate()
    }

    func getSessionState() -> SessionState? {
        return session?.state
    }

    func onImage(imageData: ImageData) {
        images.send(imageData)
        eventChannel?.sendEvent(name: NativeBridgeEvents.imageData , payload: imageData.toMap())
    }
    
    func onVitalSign(vitalSign: VitalSign) {
        if let map = vitalSign.toMap() {
            eventChannel?.sendEvent(name: NativeBridgeEvents.sessionVitalSign , payload: map)
        }
    }
    
    func onFinalResults(results: VitalSignsResults) {
        let finalResults = results.getResults().compactMap { result in
            result.toMap()
        }
        
        eventChannel?.sendEvent(name: NativeBridgeEvents.sessionFinalResults, payload: finalResults)
    }
    
    func onSessionStateChange(sessionState: SessionState) {
        eventChannel?.sendEvent(name: NativeBridgeEvents.sessionStateChange, payload: sessionState.rawValue)
    }
    
    func onWarning(warningData: WarningData) {
        eventChannel?.sendEvent(name: NativeBridgeEvents.sessionWarning, payload: warningData.toMap())
    }
    
    func onError(errorData: ErrorData) {
        eventChannel?.sendEvent(name: NativeBridgeEvents.sessionError, payload: errorData.toMap())
    }
    
    func onLicenseInfo(licenseInfo: LicenseInfo) {
        eventChannel?.sendEvent(name: NativeBridgeEvents.licenseInfo, payload: licenseInfo.toMap())
    }
    
    func onEnabledVitalSigns(enabledVitalSigns: SessionEnabledVitalSigns) {
        eventChannel?.sendEvent(name: NativeBridgeEvents.enabledVitalSigns, payload: enabledVitalSigns.toMap())
    }

    private func resolveMeasurementMode(measurementMode: Int?) -> MeasurementMode {
        if (measurementMode == MeasurementMode.finger.rawValue) {
            return MeasurementMode.finger
        }

        return MeasurementMode.face
    }

    private func resolveDeviceOrientation(deviceOrientation: Int?) -> DeviceOrientation? {
        guard let orientation = deviceOrientation, let orientationEnum = DeviceOrientation.init(rawValue: orientation) else {
            return nil
        }
        
        return orientationEnum
    }

    private func resolveSubjectDemographic(sex: Int?, age: Double?, weight: Double?) -> SubjectDemographic? {
        if (sex == nil && age == nil && weight == nil) {
            return nil
        }
        
        var sdkAge: NSNumber?
        if let age = age {
            sdkAge = NSNumber.init(value: age)
        }
        
        var sdkWeight: NSNumber?
        if let weight = weight {
            sdkWeight = NSNumber.init(value: weight)
        }
        
        return SubjectDemographic(
            sex: Sex.init(rawValue: sex ?? 0) ?? Sex.unspecified,
            age: sdkAge,
            weight: sdkWeight)
    }

    private func resolveImageFormat(imageFormatMode: Int?) -> ImageFormatMode? {
        guard let imageFormat = imageFormatMode,
              let imageFormatEnum = ImageFormatMode.init(rawValue: imageFormat) else {
            return nil
        }

        return imageFormatEnum
    }
}
