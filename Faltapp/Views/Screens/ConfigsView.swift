import SwiftUI

struct ConfigsView: View {
    var body: some View {
        ZStack {
            // Background que ocupa toda a tela
            Color(UIColor.backgroundsSecondary)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("Ajustes gerais")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.leading, 16)
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    configItem(titulo: "Preferências de notificações")
                    Divider()
                    configItem(titulo: "Armazenamento e dados")
                    Divider()
                    configItem(titulo: "Aparência")
                    Divider()
                    configItem(titulo: "Sobre o app")
                }
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                HStack {
                    Text("Ajuda e suporte")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.leading, 16)
                        .padding(.top, 24)
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    configItem(titulo: "Suporte e sugestões")
                    Divider()
                    configItem(titulo: "Links rápidos")
                    Divider()
                    configItem(titulo: "FAQs")
                }
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                Spacer() // Garante que o conteúdo não "flutue" no meio
            }
            .padding(.top, 24)
        }
        .toolbarBackground(Color(UIColor.tertiarySystemBackground), for: .navigationBar)
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
    }
    
    @ViewBuilder
    func configItem(titulo: String) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    ConfigsView()
}
