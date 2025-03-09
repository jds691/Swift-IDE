//
//  OutputView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct OutputView: View {
    @Environment(EditorContext.self) private var context
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(context.scriptOutput, id: \.message) { output in
                    Text(output.message)
                        .foregroundStyle(output.isError ? .red : .primary)
                }
            }
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
    }
}

#Preview {
    OutputView()
        .environment(EditorContext())
}
