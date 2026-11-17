//
//  Notifications.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

//
//  Notifications.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

import SwiftUI
import UserNotifications

struct Notifications: View {
    
    @AppStorage("notifications_enabled") private var notificationsEnabled = false
    @State private var showSettingsAlert = false
    
    var body: some View {
        ZStack {
            Color(UIColor.backgroundsSecondary)
                .ignoresSafeArea()
            
            
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Você pode configurar se vai ou não querer que o app te lembre de registrar suas faltas ao fim do dia.")
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    Toggle("Lembrete diário", isOn: $notificationsEnabled)
                        .padding(.horizontal, 16)
                        .onChange(of: notificationsEnabled) { newValue in
                            if newValue {
                                requestPermissionAndSchedule()
                            } else {
                                cancelNotifications()
                            }
                        }
                    
                    Spacer()
                }

            
            
            
                // Alerta quando permissão negada
                .alert("Permissão negada", isPresented: $showSettingsAlert) {
                    Button("Abrir Configurações") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Cancelar", role: .cancel) { }
                } message: {
                    Text("Para receber notificações, vá em Ajustes → Notificações → Faltapp e ative.")
                }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Funções de notificação
    
    private func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                // Já tem permissão, agenda normalmente
                NotificationScheduler.scheduleDailyReminder()
            case .denied:
                // Usuário negou permissão, mostra alerta
                DispatchQueue.main.async {
                    notificationsEnabled = false
                    showSettingsAlert = true
                }
            case .notDetermined:
                // Nunca pediu antes, pedir permissão
                center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                    DispatchQueue.main.async {
                        if granted {
                            NotificationScheduler.scheduleDailyReminder()
                        } else {
                            notificationsEnabled = false
                            showSettingsAlert = true
                        }
                    }
                }
            @unknown default:
                break
            }
        }
    }
    
    private func cancelNotifications() {
        NotificationScheduler.cancelNotifications()
    }
}

enum NotificationScheduler {
    private static let legacyIdentifier = "daily_reminder"
    private static let migrationKey = "didMigrateWeekdayNotifications"
    private static let enabledKey = "notifications_enabled"
    
    static func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Registrar faltas"
        content.body = "Não esqueça de marcar suas faltas de hoje 📅"
        content.sound = .default
        
        // Remove existing notifications first
        cancelNotifications()
        
        // Weekdays: 2 (Monday) to 6 (Friday)
        for weekday in 2...6 {
            var dateComponents = DateComponents()
            dateComponents.hour = 21
            dateComponents.minute = 30
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "daily_reminder_\(weekday)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    static func cancelNotifications() {
        var identifiers = [legacyIdentifier]
        for weekday in 2...6 {
            identifiers.append("daily_reminder_\(weekday)")
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    /// Remove a notificação diária legada (que disparava inclusive sábados e domingos)
    /// e reagenda apenas de segunda a sexta caso o lembrete esteja ativado.
    static func migrateLegacyNotificationsIfNeeded() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: migrationKey) else { return }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [legacyIdentifier])
        center.removeDeliveredNotifications(withIdentifiers: [legacyIdentifier])
        
        if defaults.bool(forKey: enabledKey) {
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    scheduleDailyReminder()
                default:
                    break
                }
            }
        }
        
        defaults.set(true, forKey: migrationKey)
    }
}

#Preview {
    Notifications()
}
