//
//  Swift_IDEApp.swift
//  Swift IDE
//
//  Created by Neo Salmon on 09/03/2025.
//

import SwiftUI

@main
struct Swift_IDEApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Swift_IDEDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
