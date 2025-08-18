//
//  FaltappApp.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 06/08/25.
//

import SwiftUI
import SwiftData

@main
struct FaltappApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: Materia.self)
    }
}
