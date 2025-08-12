//
//  CardMateria.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 08/08/25.
//

import SwiftUI

struct Materia: Identifiable{
    let id = UUID()
    let titulo: String
    let maximoFaltas: Int
    
    var datasFaltas: [Date] = []
    
    var faltas: Int {
            return datasFaltas.count
        }
}

struct CardMateria: View {
    
    let materia: Materia
    var progress: Double
    
    var faltasColor: Color {
        switch progress {
        case 0..<0.5: return .circularGreen
        case 0.5..<0.75: return .circularOrange
        default: return .circularRed
        }
    }
    
    var faltasFrases: String {
        switch progress {
        case 0..<0.5: return "Tá suave, relaxa"
        case 0.5..<0.75: return "Abre o olho tchê"
        default: return "Cuidado com o FF"
        }
    }
    
    @State private var showAddFaltaModal: Bool = false
    
    var onAdicionarFalta: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0){
            
            //Header card azul
            ZStack{
                Color.tituloCard
                HStack{
                    Text(materia.titulo)
                        .font(.system(size: 25, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .padding(.bottom, -8)
                        .padding(.leading, 16)
                    Spacer()
                    
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.blue)
                        .font(.system(size: 28))
                        .padding(.trailing, 16)
                        
                }
            }//Fim da ZStack
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            
            
            //Corpo cinza do card
            HStack(spacing: 16){
                ZStack{
                    //Insire o gráfico
                    CircularProgressView(progress: progress)
                    
                    
                    Text("\(materia.faltas)/\(materia.maximoFaltas)")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(spacing: 8){
                    HStack(spacing: 0) {
                        Text("Você está com ")
                        Text("\(materia.faltas)")
                            .foregroundColor(faltasColor)
                        Text(" faltas")
                            .foregroundStyle(faltasColor)
                    }
                    .fontWeight(.semibold)
                        
                    
                    Text(faltasFrases)
                        .fontWeight(.semibold)
                    Button{
                        print("Adicionar falta clicado")
                        showAddFaltaModal = true
                        onAdicionarFalta?()
                    }label: {
                        Text("Adicionar falta")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 28)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color(uiColor: .systemBlue))
                            )
                    }
                    .padding(.top, 8)
                    .sheet(isPresented: $showAddFaltaModal){
                        AddFaltaModal()
                    }
                    
                }

                Spacer()
            }
            .padding(.leading, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 142)
            .background(Color(UIColor.secondarySystemBackground))
            
            
        }//Fim da VStack principal
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showAddFaltaModal) {
            AddFaltaModal()
        }
        
        
    
    }
}

struct CardMateria_Previews: PreviewProvider {
    static var previews: some View {
        CardMateria(materia: Materia(titulo: "Sistemas operacionais", maximoFaltas: 6), progress: 0.2)
    }
}
