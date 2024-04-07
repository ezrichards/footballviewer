//
//  PreferencesView.swift
//  footballviewer
//
//  Created by Ethan Richards on 4/6/24.
//

import SwiftUI

struct PreferencesView: View {
    @State var preferencesController = PreferencesController()

    var body: some View {
        VStack {
            Text("API Key")
            TextField("apiKey", text: $preferencesController.apiKey)
        }
        .padding()
    }
}
