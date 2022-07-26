//
//  DeviceSettings.swift
//  Tugz
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

final class DeviceSettings: NSObject, Codable, ObservableObject {
    
    enum SoundMode: Int {
        case off
        case useDeviceSetting
        case overrideSilentSwitch
        case overrideDeviceVolume
    }
    
    enum CodingKeys: String, CodingKey {
        case soundMode
        case playSoundDuringTugging
        case launchIntoSafeMode
        case requiresAuthOnLaunch
    }

    var soundMode: SoundMode = .useDeviceSetting

    var playSoundDuringTugging = false

    var launchIntoSafeMode = false

    var requiresAuthOnLaunch = false
    
    private let jsonEncoder = JSONEncoder()
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let soundModeRaw = try values.decode(Int.self, forKey: .soundMode)
        let playSoundDuringTugging = try values.decode(Bool.self, forKey: .playSoundDuringTugging)
        let launchIntoSafeMode = try values.decode(Bool.self, forKey: .launchIntoSafeMode)
        let requiresAuthOnLaunch = try values.decode(Bool.self, forKey: .requiresAuthOnLaunch)
        
        // Safely set properties
        self.soundMode = SoundMode(rawValue: soundModeRaw) ?? .useDeviceSetting
        self.playSoundDuringTugging = playSoundDuringTugging
        self.launchIntoSafeMode = launchIntoSafeMode
        self.requiresAuthOnLaunch = requiresAuthOnLaunch
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(soundMode.rawValue, forKey: .soundMode)
        try values.encode(playSoundDuringTugging, forKey: .playSoundDuringTugging)
        try values.encode(launchIntoSafeMode, forKey: .launchIntoSafeMode)
        try values.encode(requiresAuthOnLaunch, forKey: .requiresAuthOnLaunch)
    }
    
    static func load() -> DeviceSettings {
        
        guard let data = UserDefaults.standard.object(forKey: "DeviceSettings") as? Data else {
            return DeviceSettings()
        }
        
        do {
            return try JSONDecoder().decode(DeviceSettings.self, from: data)
        } catch {
            print(error)
            return DeviceSettings()
        }
    }
    
    func save() {
        
        do {
            let data = try jsonEncoder.encode(self)
            UserDefaults.standard.set(data, forKey: "DeviceSettings")
        } catch {
            print(error)
        }
    }
}
