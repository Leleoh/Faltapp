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
    
    var faltasSegunda: Int
    var faltasTerca: Int
    var faltasQuarta: Int
    var faltasQuinta: Int
    var faltasSexta: Int
    var faltasSabado: Int
    
    var faltas: Int {
           datasFaltas.count
       }
    
    init(titulo: String,
         maximoFaltas: Int,
         faltasSegunda: Int = 0,
         faltasTerca: Int = 0,
         faltasQuarta: Int = 0,
         faltasQuinta: Int = 0,
         faltasSexta: Int = 0,
         faltasSabado: Int = 0,
         datasFaltas: [Date] = []) {
        
        self.titulo = titulo
        self.maximoFaltas = maximoFaltas
        self.faltasSegunda = faltasSegunda
        self.faltasTerca = faltasTerca
        self.faltasQuarta = faltasQuarta
        self.faltasQuinta = faltasQuinta
        self.faltasSexta = faltasSexta
        self.faltasSabado = faltasSabado
        self.datasFaltas = datasFaltas
    }
}
