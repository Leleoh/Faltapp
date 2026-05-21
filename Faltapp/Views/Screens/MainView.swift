import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showAddMateriaModal: Bool = false
    @State private var showAddFaltaModal: Bool = false
    @Query var materias: [Materia]
    
    @State private var materiaSelecionada: Materia?
    @AppStorage("ticketsRU") private var ticketsRU: String = ""
    
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
                                HStack {
                                    TextField("Tickets do RU", text: $ticketsRU)
                                        // 2. Vincula o TextField ao controle de foco
                                        .focused($isInputFocused)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 20, weight: .semibold))
                                        .padding(.vertical, 10)
                                        .frame(width: 160)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(UIColor.systemGray3), lineWidth: 1)
                                        )
                                        .onChange(of: ticketsRU) { _, newValue in
                                            let filtered = newValue.filter(\.isNumber)
                                            ticketsRU = String(filtered.prefix(6))
                                        }
                                }
                                .padding(.top, 12)
                                
                                ForEach(materias) { materia in
                                    CardMateria(
                                        materia: materia,
                                        progress: Double(materia.faltas) / Double(materia.maximoFaltas),
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
