//
//  AutoGainApp.swift
//  AutoGain
//
//  Created by 杨婧 on 2026/1/12.
//

import SwiftUI

@main
struct AutoGainApp: App {
    private let hostModel = AudioUnitHostModel()

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
