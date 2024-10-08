//
//  Extensions.swift
//  binah_flutter_sdk
//
//  Created by Giora Vered on 26/03/2023.
//

import Foundation

extension VitalSign {
    
    func toMap() -> [String: Any?]? {
        var confidence: VitalSignConfidence?
        var value: Any
        
        if let vitalSign = self as? VitalSignPulseRate {
            value = vitalSign.value
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignRespirationRate {
            value = vitalSign.value
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignSDNN {
            value = vitalSign.value
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignPRQ {
            value = vitalSign.value
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignMeanRRI {
            value = vitalSign.value
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignRRI {
            value = vitalSign.value.isEmpty ? [] : vitalSign.value.map { value in
                [
                    "interval": value.interval,
                    "timestamp": value.timestamp
                ]
            }
            confidence = vitalSign.confidence
        }
        else if let vitalSign = self as? VitalSignBloodPressure {
            value = [
                "systolic": vitalSign.value.systolic,
                "diastolic": vitalSign.value.diastolic
            ]
        }
        else if let vitalSign = self as? VitalSignStressLevel {
            value = vitalSign.value.rawValue
        }
        else if let vitalSign = self as? VitalSignPNSZone {
            value = vitalSign.value.rawValue
        }
        else if let vitalSign = self as? VitalSignSNSZone {
            value = vitalSign.value.rawValue
        }
        else if let vitalSign = self as? VitalSignWellnessLevel {
            value = vitalSign.value.rawValue
        }
        else if let vitalSign = self as? VitalSignInt {
            value = vitalSign.value
        }
        else if let vitalSign = self as? VitalSignDouble {
            value = vitalSign.value
        }
        else {
            return nil
        }
        
        var map = [
            "type": self.type,
            "value": value,
        ]
        
        if (confidence != nil) {
            map["confidence"] = [
                "level": confidence?.level.rawValue
            ]
        }
        
        return map
    }
}

extension CGRect {
    func toMap() -> [String: Int] {
        return [
            "left": Int.init(self.origin.x),
            "top": Int.init(self.origin.y),
            "width": Int.init(width),
            "height": Int.init(height)
        ]
    }
}

extension ImageData {
    func toMap() -> [String: Any?] {
        return [
            "width": Int.init(image.size.width),
            "height": Int.init(image.size.height),
            "roi": roi.isNull ? nil : roi.toMap(),
            "validity": imageValidity
        ]
    }
}

extension LicenseInfo {
    
    func toMap() -> [String: Any] {
        var map: [String: Any] = [
            "activation_id": licenseActivationInfo.activationID
        ]
        
        if let offlineMeasurements = licenseOfflineMeasurements {
            map["offline_measurements_total"] = offlineMeasurements.totalMeasurements
            map["offline_measurements_remaining"] = offlineMeasurements.remainingMeasurements
            map["offline_measurements_end_timestamp"] = offlineMeasurements.measurementEndTimestamp
        }
        
        return map
    }
}

extension SessionEnabledVitalSigns {
    
    func toMap() -> [String: Any] {
        return [
            "device_enabled": deviceEnabled.enabledVitalSigns,
            "measurement_mode_enabled": measurementModeEnabled.enabledVitalSigns,
            "license_enabled": licenseEnabled.enabledVitalSigns
        ]
    }
}

extension AlertData {
    
    func toMap() -> [String: Any] {
        return [
            "domain": domain,
            "code": code
        ]
    }
}


