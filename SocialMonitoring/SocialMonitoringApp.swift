//
//  SocialMonitoringApp.swift
//  SocialMonitoring
//
//  Created by Alexandr Bahno on 13.01.2026.
//

import SwiftUI
import Combine

@main
struct SocialMonitoringApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                permissionManager: PermissionManager(),
                activityMonitor: ActivityManager()
            )
        }
    }
}
