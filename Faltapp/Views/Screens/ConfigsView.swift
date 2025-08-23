import SwiftUI

struct ConfigsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
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
                            configItem(titulo: "Suporte e contato")
                        }
                        .buttonStyle(.plain)
                        Divider()
                        
                        NavigationLink(destination: QuickLinksView()){
                            configItem(titulo: "Links rápidos")
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Seção de Instagram (promoção do dev)
                    VStack(spacing: 8) {
                        HStack {
                            Text("Siga o desenvolvedor :)")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.top, 16)
                        
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(.graysGray2)
                            Text("@leonel.ferraz")
                                .foregroundColor(.blue)
                                .underline()
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            
                            if let appURL = URL(string: "instagram://user?username=leonel.ferraz"),
                               UIApplication.shared.canOpenURL(appURL) {
                                UIApplication.shared.open(appURL)
                            } else if let webURL = URL(string: "https://instagram.com/leonel.ferraz") {
                                UIApplication.shared.open(webURL)
                            }
                        }
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Configurações")
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
