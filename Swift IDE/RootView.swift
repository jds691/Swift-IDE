//
//  ContentView.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

struct RootView: View {
    @Binding var document: SwiftDocument
    
    @Environment(\.documentConfiguration) private var documentConfig: DocumentConfiguration?
    
    @Environment(EditorContext.self) private var context: EditorContext
    
    @State private var showMustSaveScriptAlert: Bool = false

    var body: some View {
        HSplitView {
            EditorView(document: $document)
            OutputView()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if context.isScriptRunning {
                    ProgressView()
                } else {
                    Button {
                        if let documentConfig, let documentURL = documentConfig.fileURL {
                            context.runScript(documentURL)
                        } else {
                            showMustSaveScriptAlert = true
                        }
                    } label: {
                        Label("Run", systemImage: "play.fill")
                    }
                }
                
                if context.isScriptRunning {
                    Button {
                        context.terminateScript()
                    } label: {
                        Label("Terminate", systemImage: "stop.fill")
                    }
                }
            }
        }
        
        // MARK: Alerts
        .alert("Cannot Run Script", isPresented: $showMustSaveScriptAlert, actions: {
            
        }, message: {
            Text("Please save your script to a file before running it.")
        })
    }
}

#Preview {
    RootView(document: .constant(SwiftDocument()))
        .environment(EditorContext())
}
