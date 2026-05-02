import SwiftUI

struct TutorDetailView: View {
    let tutor: Tutor
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Top Header: Foto grande
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 130, height: 130)
                        
                        if let imagemNome = tutor.imagemNome {
                            Image(imagemNome)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 122, height: 122)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 122, height: 122)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .clipShape(Circle())
                        }
                    }
                    .shadow(color: .teal.opacity(0.4), radius: 15, x: 0, y: 5)
                    
                    VStack(spacing: 8) {
                        Text(tutor.nome)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(tutor.titulacao)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "building.columns.fill")
                                .font(.caption)
                            Text("UFRGS")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                
                // Info Cards (Preço e Área)
                HStack(spacing: 16) {
                    InfoBox(title: "ÁREA GERAL", value: tutor.areaGeral, icon: "books.vertical.fill", color: .purple)
                    InfoBox(title: "PREÇO/HORA", value: tutor.precoPorHora, icon: "dollarsign.circle.fill", color: .green)
                }
                .padding(.horizontal)
                
                // Matérias
                VStack(alignment: .leading, spacing: 12) {
                    Text("Matérias Lecionadas")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    // Wrapping tags
                    FlowLayout(spacing: 8) {
                        ForEach(tutor.materias, id: \.self) { materia in
                            Text(materia)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.teal.opacity(0.15))
                                .foregroundColor(.teal)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                
                // Sobre
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sobre as aulas")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(tutor.biografia)
                        .font(.body)
                        .foregroundColor(.primary.opacity(0.85))
                        .lineSpacing(4)
                }
                .padding(.horizontal)
                
                // Espaço extra pro final da tela não ficar colado no botão
                Spacer().frame(height: 100)
            }
        }
        .navigationTitle("Perfil do Tutor")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            // Botão Contato Flutuante
            Button(action: {
                let mensagem = "Olá! Te encontrei no Faltapp e gostaria de saber mais sobre as aulas particulares."
                let mensagemEncoded = mensagem.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let urlString = "whatsapp://send?phone=\(tutor.telefone)&text=\(mensagemEncoded)"
                if let url = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        if let webUrl = URL(string: "https://wa.me/\(tutor.telefone)?text=\(mensagemEncoded)") {
                            UIApplication.shared.open(webUrl)
                        }
                    }
                }
            }) {
                HStack {
                    Image(systemName: "message.fill")
                        .font(.title3)
                    Text("Entrar em Contato")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: .teal.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            .background(
                LinearGradient(colors: [Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground)], startPoint: .top, endPoint: .bottom)
            )
        }
    }
}

// Subcomponente de caixinha de info
struct InfoBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(16)
    }
}

// Um simples FlowLayout em SwiftUI (HStack que quebra linha)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0
        for row in rows {
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            height += rowHeight + spacing
        }
        return CGSize(width: proposal.width ?? 0, height: max(0, height - spacing))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for view in row {
                let viewSize = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(viewSize))
                x += viewSize.width + spacing
            }
            y += rowHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var currentRow = 0
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? UIScreen.main.bounds.width
        
        for view in subviews {
            let width = view.sizeThatFits(.unspecified).width
            if x + width > maxWidth {
                currentRow += 1
                rows.append([])
                x = 0
            }
            rows[currentRow].append(view)
            x += width + spacing
        }
        return rows
    }
}

#Preview {
    NavigationStack {
        TutorDetailView(tutor: Tutor.mocks[0])
    }
}
