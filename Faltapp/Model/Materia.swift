//
//  Materia.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 13/08/25.
//

import Foundation
import SwiftData

@Model
final class Materia: Identifiable {
    var id = UUID()
    var titulo: String
    var maximoFaltas: Int
    var datasFaltas: [Date]
    
    var faltas: Int {
           datasFaltas.count
       }
    
    init(titulo: String, maximoFaltas: Int, datasFaltas: [Date] = []) {
            self.titulo = titulo
            self.maximoFaltas = maximoFaltas
            self.datasFaltas = datasFaltas
        }
}
