import SwiftUI
import SafariServices

struct UFRGSView: View {
    @State private var activeLink: UFRGSLink? = nil
    
    private let dailyLinks: [UFRGSLink] = [
        UFRGSLink(
            title: "Cardápio do RU",
            subtitle: "Almoço e jantar",
            icon: "fork.knife",
            color: .orange,
            urlString: "https://www.ufrgs.br/prae/cardapio-ru/"
        ),
        UFRGSLink(
            title: "Mapas dos Campus",
            subtitle: "Prédios e setores",
            icon: "map.fill",
            color: .green,
            urlString: "https://www1.ufrgs.br/infraestrutura/geolocation/index.php?verb=pan&codpredio="
        ),
        UFRGSLink(
            title: "Calendário Escolar",
            subtitle: "Datas e feriados",
            icon: "calendar",
            color: .blue,
            urlString: "https://www.ufrgs.br/prograd/prograd/calendario-escolar/"
        ),
        UFRGSLink(
            title: "Horários e Vagas",
            subtitle: "Grade de cadeiras",
            icon: "clock.fill",
            color: .purple,
            urlString: "https://www1.ufrgs.br/graduacao/ArquivosCompartilhados/SelGrupoMatricula.php?tipo=gm&ret=../../graduacao/ArquivosCompartilhados/Horariosvagas.php"
        )
    ]
    
    private let systemLinks: [UFRGSLink] = [
        UFRGSLink(
            title: "Portal do Aluno",
            subtitle: "Requer login UFRGS",
            icon: "person.badge.key.fill",
            color: .cyan,
            urlString: "https://www1.ufrgs.br/sistemas/portal/?Destino=ccd7f388f9a3e25ef6aff3b98c773f65"
        ),
        UFRGSLink(
            title: "E-mail UFRGS (Chasque)",
            subtitle: "Requer login UFRGS",
            icon: "envelope.fill",
            color: .teal,
            urlString: "https://webmail.ufrgs.br/chasque/"
        ),
        UFRGSLink(
            title: "TUAUFRGS",
            subtitle: "Guia acadêmico",
            icon: "info.circle.fill",
            color: .indigo,
            urlString: "https://www.ufrgs.br/tuaufrgs/"
        )
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Card longo em destaque: Tutores UFRGS
                    NavigationLink(destination: TutorsView()) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.indigo, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "graduationcap.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tutores UFRGS")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Aulas particulares com desconto exclusivo Faltapp")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.purple.opacity(0.35), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Seção: Dia a dia (sem login)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionPillHeader(title: "Dia a dia", color: .blue)
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(dailyLinks) { item in
                                Button {
                                    activeLink = item
                                } label: {
                                    UFRGSGridCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Seção: Sistemas (abre no Safari in-app)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionPillHeader(title: "Sistemas", color: .teal)
                        
                        VStack(spacing: 0) {
                            ForEach(Array(systemLinks.enumerated()), id: \.element.id) { index, item in
                                Button {
                                    activeLink = item
                                } label: {
                                    HStack(spacing: 14) {
                                        Image(systemName: item.icon)
                                            .font(.title3)
                                            .foregroundColor(item.color)
                                            .frame(width: 36, height: 36)
                                            .background(item.color.opacity(0.15))
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.title)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundColor(.primary)
                                            Text(item.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.caption.weight(.semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                
                                if index < systemLinks.count - 1 {
                                    Divider()
                                        .padding(.leading, 64)
                                }
                            }
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("UFRGS")
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
            .sheet(item: $activeLink) { link in
                if let url = URL(string: link.urlString) {
                    SafariWebView(url: url)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

private struct UFRGSLink: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let urlString: String
}

private struct SectionPillHeader: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.subheadline.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(color.opacity(0.85))
            .clipShape(Capsule())
    }
}

private struct UFRGSGridCard: View {
    let item: UFRGSLink
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(item.color.opacity(0.16))
                    .frame(width: 52, height: 52)
                
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(item.color)
            }
            
            VStack(spacing: 3) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(item.subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 132)
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.preferredControlTintColor = .systemBlue
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    UFRGSView()
        .preferredColorScheme(.dark)
}
