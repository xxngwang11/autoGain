//
//  AutoGainExtensionMainView.swift
//  AutoGainExtension
//
//  Created by 杨婧 on 2026/1/12.
//

import SwiftUI

struct AutoGainExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
