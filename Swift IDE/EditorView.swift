//
//  EditorView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct EditorView: View {
    @Environment(EditorContext.self) private var context: EditorContext
    @Binding var document: SwiftDocument
    
    var body: some View {
        @Bindable var bindableContext = context
        
        TextEditor(text: $document.text, selection: $bindableContext.editorTextSelection)
            .font(.custom("SF Mono", size: 12))
    }
}


#Preview {
    EditorView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
