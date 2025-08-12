//
//  FaltappApp.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 06/08/25.
//

import SwiftUI
import TipKit

@main
struct FaltappApp: App {
    
    init() {
            try? Tips.configure()
        }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
