import SwiftUI

struct RUSyncModal: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var ticketsRU: String
    @Binding var ticketsRURestantes: String
    var onSyncStatusChange: (() -> Void)? = nil
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isConnected: Bool = KeychainHelper.hasCredentials
    
    var body: some View {
        NavigationStack {
            Form {
                if isConnected {
                    Section {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sincronização ativa")
                                    .font(.headline)
                                if let saved = KeychainHelper.loadCredentials() {
                                    Text("Cartão/CPF: \(saved.username)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Section {
                        Button {
                            Task {
                                await syncNowUsingSavedCredentials()
                            }
                        } label: {
                            HStack {
                                Text("Sincronizar agora")
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                }
                            }
                        }
                        .disabled(isLoading)
                    }
                    
                    Section {
                        Button("Desconectar conta", role: .destructive) {
                            KeychainHelper.deleteCredentials()
                            ticketsRURestantes = ""
                            isConnected = false
                            errorMessage = nil
                            onSyncStatusChange?()
                            dismiss()
                        }
                    } footer: {
                        Text("Ao desconectar, suas credenciais são apagadas do Keychain e você continua podendo editar os tickets manualmente.")
                    }
                } else {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sincronize seus tickets do RU automaticamente com o Portal da UFRGS.")
                                .font(.subheadline)
                            Text("Seus dados ficam salvos apenas no Keychain do seu iPhone e são enviados somente ao Portal da UFRGS.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Section("Dados do Portal UFRGS") {
                        TextField("Cartão UFRGS ou CPF", text: $username)
                            .keyboardType(.numberPad)
                            .onChange(of: username) { _, newValue in
                                username = String(newValue.filter(\.isNumber).prefix(11))
                            }
                        
                        SecureField("Senha do Portal", text: $password)
                    }
                    
                    Section {
                        Button {
                            Task {
                                await connectAndSync()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Conectar e sincronizar")
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                            }
                        }
                        .disabled(username.isEmpty || password.isEmpty || isLoading)
                    }
                }
                
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Tickets do RU")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func connectAndSync() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let info = try await RUTicketSyncService.fetchTicketsInfo(
                username: username,
                password: password
            )
            KeychainHelper.saveCredentials(username: username, password: password)
            ticketsRURestantes = String(info.availableCount)
            if let code = info.ticketCode {
                ticketsRU = code
            }
            isConnected = true
            onSyncStatusChange?()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func syncNowUsingSavedCredentials() async {
        guard let saved = KeychainHelper.loadCredentials() else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let info = try await RUTicketSyncService.fetchTicketsInfo(
                username: saved.username,
                password: saved.password
            )
            ticketsRURestantes = String(info.availableCount)
            if let code = info.ticketCode {
                ticketsRU = code
            }
            onSyncStatusChange?()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    RUSyncModal(ticketsRU: .constant("832483"), ticketsRURestantes: .constant("29"))
        .preferredColorScheme(.dark)
}
