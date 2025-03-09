//
//  EditorView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct EditorView: View {
    @Binding var document: SwiftDocument
    
    var body: some View {
        TextEditor(text: $document.text)
            .font(.custom("SF Mono", size: 12))
    }
}


#Preview {
    EditorView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
