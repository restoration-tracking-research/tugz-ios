//
//  DeviceSettings.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation

/*
 Device-specific settings like
 - Does the device make a sound when notifications arrive?
 - Does the device make periodic sounds during tugging, i.e. every 15 sec?
 - Should the app launch into a privacy-sensitive mode by default?
 - Should the app require faceID/touchID on launch?
 */

struct DeviceSettings {
    
    enum SoundMode {
        case off
        case useDeviceSetting
        case overrideSilentSwitch
        case overrideDeviceVolume
    }
    
    var soundMode: SoundMode = .useDeviceSetting
    
    var playSoundDuringTugging = false
    
    var launchIntoSafeMode = false
    
    var requiresAuthOnLaunch = false
}
