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
    @FocusState private var isFocused: Bool
    @State private var isUpdatingFocus: Bool = false
    
    var body: some View {
        @Bindable var bindableContext = context
        
        TextEditor(text: $document.text, selection: $bindableContext.editorTextSelection)
            .font(.custom("SF Mono", size: 12))
            .focused($isFocused)
            .onChange(of: context.isEditorFocused) {
                if isUpdatingFocus {
                    return
                }
                
                if context.isEditorFocused {
                    isUpdatingFocus = true
                    isFocused = true
                    isUpdatingFocus = false
                }
            }
            .onChange(of: isFocused) {
                if isUpdatingFocus {
                    return
                }
                
                isUpdatingFocus = true
                context.isEditorFocused = isFocused
                isUpdatingFocus = false
            }
    }
}


#Preview {
    EditorView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
