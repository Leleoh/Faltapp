import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var showAddMateriaModal: Bool = false
    @State private var showAddFaltaModal: Bool = false
    @State private var showRUSyncModal: Bool = false
    @State private var isSyncingRU: Bool = false
    @State private var isRUSyncConnected: Bool = KeychainHelper.hasCredentials
    @Query var materias: [Materia]
    
    @State private var materiaSelecionada: Materia?
    @AppStorage("ticketsRU") private var ticketsRU: String = ""
    @AppStorage("ticketsRURestantes") private var ticketsRURestantes: String = ""
    @AppStorage("hasSeenRUSyncTip") private var hasSeenRUSyncTip: Bool = false
    @AppStorage("lastRUSyncTimestamp") private var lastRUSyncTimestamp: Double = 0
    
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fundo Global (Cinza) - Área do Título
                Color(UIColor.tertiarySystemBackground)
                    .ignoresSafeArea()
                
                if materias.isEmpty {
                    // MARK: - Empty State
                    VStack {
                        Spacer()
                        
                        Image(systemName: "books.vertical.fill")
                            .resizable()
                            .frame(width: 62, height: 61)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                        
                        Text("Nenhuma matéria adicionada")
                            .fontWeight(.semibold)
                        
                        Text("Adicione uma matéria e ela será mostrada aqui")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .padding(.top, 8)
                        
                        Button(action: {
                            showAddMateriaModal = true
                        }){
                            Text("Adicionar matéria")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color(UIColor.systemBlue))
                                )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        Spacer()
                        
                        // Banner de Promoção do Instagram no Empty State
                        Button(action: {
                            if let appURL = URL(string: "instagram://user?username=leonel.ferraz"),
                               UIApplication.shared.canOpenURL(appURL) {
                                UIApplication.shared.open(appURL)
                            } else if let webURL = URL(string: "https://instagram.com/leonel.ferraz") {
                                UIApplication.shared.open(webURL)
                            }
                        }) {
                            HStack(spacing: 12) {
                                LinearGradient(
                                    colors: [.purple, .pink, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 32, height: 32)
                                .mask(
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Acompanhe as novidades!")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("Siga o criador do Faltapp no Instagram")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 48)
                    }
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    
                } else {
                    // MARK: - Lista com Scroll
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            LazyVStack(spacing: 16) {
                                VStack(spacing: 8) {
                                    HStack(spacing: 10) {
                                        TextField("Ticket do RU", text: $ticketsRU)
                                            .focused($isInputFocused)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 20, weight: .semibold))
                                            .padding(.vertical, 10)
                                            .frame(width: 150)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color(UIColor.systemGray3), lineWidth: 1)
                                            )
                                            .onChange(of: ticketsRU) { _, newValue in
                                                let filtered = newValue.filter(\.isNumber)
                                                ticketsRU = String(filtered.prefix(6))
                                            }
                                        
                                        if isRUSyncConnected && !ticketsRURestantes.isEmpty {
                                            HStack(spacing: 5) {
                                                Image(systemName: "ticket.fill")
                                                    .font(.caption)
                                                Text("\(ticketsRURestantes) rest.")
                                                    .font(.subheadline.weight(.semibold))
                                            }
                                            .foregroundColor(.green)
                                            .padding(.horizontal, 12)
                                            .frame(height: 44)
                                            .background(Color.green.opacity(0.14))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                        
                                        Button {
                                            showRUSyncModal = true
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(isRUSyncConnected ? Color.green.opacity(0.15) : Color(UIColor.secondarySystemBackground))
                                                    .frame(width: 44, height: 44)
                                                
                                                if isSyncingRU {
                                                    ProgressView()
                                                } else {
                                                    Image(systemName: "arrow.triangle.2.circlepath")
                                                        .font(.system(size: 17, weight: .semibold))
                                                        .foregroundColor(isRUSyncConnected ? .green : .blue)
                                                }
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .accessibilityLabel("Sincronizar tickets do RU")
                                    }
                                    
                                    if !isRUSyncConnected && !hasSeenRUSyncTip {
                                        Button {
                                            hasSeenRUSyncTip = true
                                            isInputFocused = false
                                            showRUSyncModal = true
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "info.circle")
                                                Text("Toque em ↻ para sincronizar ticket e saldo com o Portal")
                                            }
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.top, 12)
                                
                                ForEach(materias) { materia in
                                    let progress = materia.maximoFaltas > 0
                                        ? Double(materia.faltas) / Double(materia.maximoFaltas)
                                        : 0
                                    CardMateria(
                                        materia: materia,
                                        progress: progress,
                                        onAdicionarFalta: { novasDatas in
                                            materia.datasFaltas = novasDatas
                                            try? modelContext.save()
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.bottom, 100)
                            
                            Spacer()
                        }
                        .frame(minHeight: geometry.size.height)
                        .background(Color(UIColor.systemBackground))
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            // MARK: - Modificadores de Navegação
            .navigationTitle("Matérias")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(UIColor.tertiarySystemBackground), for: .navigationBar)
            .toolbarVisibility(.visible, for: .navigationBar)
            
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor.tabViewBG), for: .tabBar)
            
            .toolbar {
                // 3. Adiciona a barra acima do teclado numérico
                if isInputFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // Empurra pra direita
                        Button("OK") {
                            isInputFocused = false
                        }
                        .fontWeight(.bold)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddMateriaModal = true
                    } label: {
                        Image("AddMateria")
                            .resizable()
                            .frame(width: 34, height: 34)
                            .scaledToFit()
                    }
                }
            }
            .sheet(isPresented: $showAddMateriaModal) {
                AddMateriaModal{ materia in
                    modelContext.insert(materia)
                    showAddMateriaModal = false
                }
            }
            .sheet(isPresented: $showRUSyncModal) {
                RUSyncModal(ticketsRU: $ticketsRU, ticketsRURestantes: $ticketsRURestantes) {
                    isRUSyncConnected = KeychainHelper.hasCredentials
                    if isRUSyncConnected {
                        hasSeenRUSyncTip = true
                        lastRUSyncTimestamp = Date().timeIntervalSince1970
                    }
                }
            }
            .task {
                await syncTicketsIfNeeded()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task {
                        await syncTicketsIfNeeded()
                    }
                }
            }
        }
    }
    
    private func syncTicketsIfNeeded() async {
        isRUSyncConnected = KeychainHelper.hasCredentials
        guard let credentials = KeychainHelper.loadCredentials() else { return }
        
        // Evita múltiplas requisições se acabou de sincronizar (intervalo mínimo de 5 minutos)
        let now = Date().timeIntervalSince1970
        guard now - lastRUSyncTimestamp > 300 else { return }
        
        isSyncingRU = true
        defer { isSyncingRU = false }
        
        if let info = try? await RUTicketSyncService.fetchTicketsInfo(
            username: credentials.username,
            password: credentials.password
        ) {
            ticketsRURestantes = String(info.availableCount)
            if let code = info.ticketCode {
                ticketsRU = code
            }
            lastRUSyncTimestamp = Date().timeIntervalSince1970
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Materia.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let context = container.mainContext
    
    context.insert(
        Materia(
            titulo: "Cálculo I",
            maximoFaltas: 20,
            faltasSegunda: 2,
            faltasTerca: 0,
            faltasQuarta: 1,
            faltasQuinta: 0,
            faltasSexta: 0,
            faltasSabado: 0
        )
    )
    
    return NavigationStack {
        MainView()
    }
    .modelContainer(container)
}
