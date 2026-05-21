import SwiftUI

struct TutorCardView: View {
    let tutor: Tutor
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header: Foto, Nome, Titulação
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 70, height: 70)
                    
                    if let imagemNome = tutor.imagemNome {
                        Image(imagemNome)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 66, height: 66)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 66, height: 66)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tutor.nome)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(tutor.titulacao)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "building.columns.fill")
                            .font(.caption2)
                        Text("UFRGS")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            
            // Área Geral e Preço
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("ÁREA GERAL")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(tutor.areaGeral)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("PREÇO")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(tutor.precoPorHora)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            
            // Matérias (Tags)
            VStack(alignment: .leading, spacing: 8) {
                Text("MATÉRIAS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                // Simples ScrollView horizontal para as tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tutor.materias, id: \.self) { materia in
                            Text(materia)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.teal.opacity(0.2))
                                .foregroundColor(.teal)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            // Biografia Resumida
            Text(tutor.biografia)
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.8))
                .lineLimit(2)
                .padding(.top, 4)
            
            // Um pequeno indicativo de que é clicável
            HStack {
                Spacer()
                Text("Ver Detalhes")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.teal)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.teal)
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(.ultraThinMaterial) // Efeito Glassmorphism
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TutorCardView(tutor: Tutor.mocks[0])
            .padding()
            .preferredColorScheme(.dark)
    }
}
