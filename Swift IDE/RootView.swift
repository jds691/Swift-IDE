//
//  ContentView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct RootView: View {
    @Binding var document: SwiftDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    RootView(document: .constant(SwiftDocument()))
}
