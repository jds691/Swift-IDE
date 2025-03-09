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
        List {
            ForEach(context.scriptOutput, id: \.message) { output in
                Text(output.message)
                    .foregroundStyle(output.isError ? .red : .primary)
            }
        }
    }
}

#Preview {
    OutputView()
        .environment(EditorContext())
}
