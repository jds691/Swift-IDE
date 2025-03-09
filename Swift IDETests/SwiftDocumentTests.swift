//
//  SwiftDocumentTests.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import Testing
@testable import Swift_IDE

struct SwiftDocumentTests {
    @Test func getIndexAtTests() async throws {
        let documentContents: String =
        """
        import Foundation
        
        print("Hello, World!")
        
        do {
            Thread.sleep(forTimeInterval: 5)
        }
        
        print("Hello, Again"!)
        """
        
        let document: SwiftDocument = SwiftDocument(text: documentContents)
        
        #expect(document.getIndexAt(line: 6, column: 5) == 47)
    }
}

