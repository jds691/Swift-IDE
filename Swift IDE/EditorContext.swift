//
//  EditorContext.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import Foundation
import SwiftUI

struct ScriptOutput {
    var message: String
    var isError: Bool
}

@Observable
public class EditorContext {
    private var currentProcess: Process?
    
    var isScriptRunning: Bool = false
    var scriptOutput: [ScriptOutput] = []
    var scriptExitCode: Int32? = nil
    
    /// Executes a swift source file and monitors it
    /// - Parameter fileURL: URL of the swift file to execute
    public func runScript(_ fileURL: URL) {
        scriptOutput = []
        
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
    
    private func handleProcessOutput(_ handle: FileHandle, isError: Bool) {
        if let line = String(data: handle.availableData, encoding: .utf8), !line.isEmpty {
            // Update your view with the new text here
            if isError {
                print("New error: \(line)")
                scriptOutput.append(ScriptOutput(message: line, isError: true))
            } else {
                print("New ouput: \(line)")
                scriptOutput.append(ScriptOutput(message: line, isError: false))
            }
        }
    }
}
