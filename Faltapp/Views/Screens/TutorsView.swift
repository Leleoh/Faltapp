import SwiftUI

struct TutorsView: View {
    let tutores = Tutor.mocks
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background da view para combinar com o app
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Banner de Desconto Faltapp
                        HStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Desconto Exclusivo!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Diga que veio pelo Faltapp ao entrar em contato e garanta um desconto na sua aula.")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(color: .indigo.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        ForEach(tutores) { tutor in
                            NavigationLink(destination: TutorDetailView(tutor: tutor)) {
                                TutorCardView(tutor: tutor)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle()) // Pra não ficar azul de link padrão
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Tutores UFRGS")
        }
    }
}

#Preview {
    TutorsView()
}
