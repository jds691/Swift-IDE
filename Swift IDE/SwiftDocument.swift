//
//  Swift_IDEDocument.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct SwiftDocument: FileDocument {
    var text: String

    init(text: String = "print(\"Hello, world!\")") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.swiftSource] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    func getIndexAt(line: Int, column: Int) -> Int {
        let textLines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
        
        var currentIndex: Int = 0
        
        for i in 0...line - 2 {
            currentIndex += textLines[i].count
        }
        
        currentIndex += column - 1
        
        return currentIndex
    }
    
    func getIndexAt(line: Int, column: Int) -> String.Index {
        let textLines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
        
        return text.index(textLines[line - 1].startIndex, offsetBy: column - 1)
    }
}
