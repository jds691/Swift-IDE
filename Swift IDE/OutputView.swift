//
//  OutputView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct OutputView: View {
    @Environment(EditorContext.self) private var context
    
    @Binding var document: SwiftDocument
    
    @State private var selectedOutput: Int = 0
    
    @State private var showUnableToNavigateToErrorAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(context.scriptOutput, id: \.message) { output in
                    Text(output.message)
                        .foregroundStyle(output.isError ? .red : .primary)
                        .font(.custom("SF Mono", size: 12))
                        .onTapGesture {
                            if let selection = output.relevantSelection {
                                handleTextNavigation(to: selection)
                            }
                        }
                }
            }
            .listStyle(.bordered)
            Group {
                if context.isScriptRunning {
                    Label("Running...", systemImage: "clock")
                } else {
                    if let exitCode = context.scriptExitCode {
                        if exitCode == 0 {
                            Label("Program finished with exit code \(exitCode).", systemImage: "checkmark.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.primary, .green)
                        } else {
                            Label("Program finished with exit code \(exitCode).", systemImage: "xmark.circle.fill")
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                }
            }
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity)
        }
        .alert("Unable to navigate to error", isPresented: $showUnableToNavigateToErrorAlert, actions: {}) {
            Text("Could not determine location of error in script.")
        }
    }
    
    private func handleTextNavigation(to lineCol: String) {
        let components = lineCol.split(separator: ":")
        
        if let line = Int(components[0]), let column = Int(components[1]) {
            let index: String.Index = document.getIndexAt(line: line, column: column)
            context.isEditorFocused = true
            context.editorTextSelection = TextSelection(insertionPoint: index)
        } else {
            showUnableToNavigateToErrorAlert = true
        }
    }
}

#Preview {
    OutputView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
