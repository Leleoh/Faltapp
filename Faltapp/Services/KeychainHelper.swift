import Foundation
import Security

enum KeychainHelper {
    private static let service = "br.academy.Faltapp.ufrgs"
    private static let usernameAccount = "ufrgs_username"
    private static let passwordAccount = "ufrgs_password"
    
    static var hasCredentials: Bool {
        loadCredentials() != nil
    }
    
    @discardableResult
    static func saveCredentials(username: String, password: String) -> Bool {
        let userSaved = save(value: username, account: usernameAccount)
        let passSaved = save(value: password, account: passwordAccount)
        return userSaved && passSaved
    }
    
    static func loadCredentials() -> (username: String, password: String)? {
        guard let username = load(account: usernameAccount),
              let password = load(account: passwordAccount),
              !username.isEmpty,
              !password.isEmpty else {
            return nil
        }
        return (username, password)
    }
    
    static func deleteCredentials() {
        delete(account: usernameAccount)
        delete(account: passwordAccount)
    }
    
    private static func save(value: String, account: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        delete(account: account)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private static func load(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Foundation.Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
    
    private static func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
