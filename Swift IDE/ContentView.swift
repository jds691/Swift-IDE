//
//  ContentView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: Swift_IDEDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(Swift_IDEDocument()))
}
