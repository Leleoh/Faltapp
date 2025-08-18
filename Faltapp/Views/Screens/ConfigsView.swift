import SwiftUI

struct ConfigsView: View {
    var body: some View {
        NavigationStack {   // << precisa disso para ativar a navegação
            ZStack {
                // Background que ocupa toda a tela
                Color(UIColor.backgroundsSecondary)
                    .ignoresSafeArea()

                VStack {
                    // Ajustes gerais
                    HStack {
                        Text("Ajustes gerais")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    
                    VStack(spacing: 0) {
                        NavigationLink(destination: Notifications()) {
                            configItem(titulo: "Preferências de notificações")
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        NavigationLink(destination: Data()){
                            configItem(titulo: "Armazenamento e dados")
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        configItem(titulo: "Aparência")
                        
                        Divider()
                        
                        NavigationLink(destination: About()){
                            configItem(titulo: "Sobre o app")
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Ajuda e suporte
                    HStack {
                        Text("Ajuda e suporte")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                            .padding(.top, 24)
                        Spacer()
                    }
                    
                    VStack(spacing: 0) {
                        NavigationLink(destination: Support()){
                            configItem(titulo: "Suporte e sugestões")
                        }
                        .buttonStyle(.plain)
                        Divider()
                        
                        NavigationLink(destination: QuickLinksView()){
                            configItem(titulo: "Links rápidos")
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        configItem(titulo: "FAQs")
                    }
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Configurações") // título da tela
            .toolbarBackground(Color(UIColor.tertiarySystemBackground), for: .navigationBar)
            .toolbarVisibility(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
            .toolbarBackgroundVisibility(.visible, for: .tabBar)
        }
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
