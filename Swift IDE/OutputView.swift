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
                            Label("Program exited with code: \(exitCode)", systemImage: "checkmark.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.primary, .green)
                        } else {
                            Label("Program exited with code: \(exitCode)", systemImage: "xmark.circle.fill")
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                }
            }
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity)
        }
        .onChange(of: selectedOutput) {
            print(selectedOutput)
        }
    }
    
    private func handleTextNavigation(to lineCol: String) {
        let components = lineCol.split(separator: ":")
        let index: String.Index = document.getIndexAt(line: Int(components[0])!, column: Int(components[1])!)
        context.isEditorFocused = true
        context.editorTextSelection = TextSelection(insertionPoint: index)
    }
}

#Preview {
    OutputView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
