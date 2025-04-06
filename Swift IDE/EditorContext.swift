//
//  EditorContext.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import Foundation
import SwiftUI

/// Represents the output produced by stdout and stderr
struct ScriptOutput {
    /// Message output
    var message: String
    /// Indicates if the error was produced by stderr
    var isError: Bool
    /// Represents the line and column number relevant to this output
    var relevantSelection: String?
}

@Observable
public class EditorContext {
    private var currentProcess: Process?
    
    /// Indicates if there is a running swift instance
    var isScriptRunning: Bool = false
    // TODO: Seems to be improperly cleared when the contents of the EditorView are modified
    /// Output of the current process
    ///
    /// This output is cleared when running the script again
    var scriptOutput: [ScriptOutput] = []
    /// Exit code of the last ran script
    ///
    /// This exit code is cleared when running the script again
    var scriptExitCode: Int32? = nil
    /// Indicates if the editor pane is actively focused
    var isEditorFocused: Bool = false
    /// The currently selected text by the editor
    ///
    /// Used to change the cursor position when clicking on an error
    var editorTextSelection: TextSelection?
    
    /// Executes a swift source file and monitors it
    /// - Parameter fileURL: URL of the swift file to execute
    public func runScript(_ fileURL: URL) {
        scriptOutput = []
        scriptExitCode = nil
        
        currentProcess = Process()
        guard let currentProcess else { return }
        currentProcess.executableURL = URL(string: "file:///usr/bin/env")
        currentProcess.arguments = [
            "swift",
            fileURL.path()
        ]
        
        let standardOutPipe = Pipe()
        let standardErrPipe = Pipe()
        
        standardOutPipe.fileHandleForReading.readabilityHandler = { pipe in
            self.handleProcessOutput(pipe, isError: false)
        }
        
        standardErrPipe.fileHandleForReading.readabilityHandler = { pipe in
            self.handleProcessOutput(pipe, isError: true)
        }
        
        currentProcess.standardOutput = standardOutPipe
        currentProcess.standardError = standardErrPipe
        currentProcess.qualityOfService = .userInitiated
        currentProcess.terminationHandler = { process in
            self.isScriptRunning = false
            self.scriptExitCode = process.terminationStatus
        }
        
        do {
            isScriptRunning = true
            try currentProcess.run()
        } catch {
            isScriptRunning = false
        }
    }
    
    /// Terminates the swift process if it is currently running a script
    public func terminateScript() {
        if let currentProcess {
            currentProcess.terminate()
        }
    }
    
    private func handleProcessOutput(_ handle: FileHandle, isError: Bool) {
        if let line = String(data: handle.availableData, encoding: .utf8), !line.isEmpty {
            if isError {
                let components = line.split(separator: ":")
                let errorOrigin: String = "\(components[1]):\(components[2])"
                scriptOutput.append(ScriptOutput(message: line, isError: true, relevantSelection: errorOrigin))
            } else {
                scriptOutput.append(ScriptOutput(message: line, isError: false))
            }
        }
    }
}
