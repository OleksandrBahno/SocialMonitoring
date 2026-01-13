//
//  PermissionManager.swift
//  SocialMonitoring
//
//  Created by Alexandr Bahno on 13.01.2026.
//

import Cocoa
import ApplicationServices
import CoreGraphics
import Combine

protocol PermissionManagerProtocol: ObservableObject {
    var arePermissionsGranted: Bool { get }
    func askForPermissions()
    func openSettings()
}

final class PermissionManager {
    
    @Published var isAccessibilityEnable = false
    @Published var isScreenRecordingEnable = false
    
    private func checkAccessibility() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        return isTrusted
    }
    
    private func checkScreenRecording() -> Bool {
        // It returns true if app has permission, false otherwise.
        if CGPreflightScreenCaptureAccess() {
            return true
        } else {
            // If app doesn't have permission, we request it explicitly.
            CGRequestScreenCaptureAccess()
            return false
        }
    }
}

// MARK: - PermissionManagerProtocol
extension PermissionManager: PermissionManagerProtocol {
    // Returns FALSE if permissions are missing
    var arePermissionsGranted: Bool {
        return isAccessibilityEnable && isScreenRecordingEnable
    }
    
    func askForPermissions() {
        isAccessibilityEnable = checkAccessibility()
        isScreenRecordingEnable = checkScreenRecording()
    }
    
    func openSettings() {
        if let url = URL(
            string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
        ) {
            NSWorkspace.shared.open(url)
        }
    }
}
