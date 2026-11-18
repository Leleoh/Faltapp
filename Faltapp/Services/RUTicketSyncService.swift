import Foundation

struct RUTicketsInfo {
    let availableCount: Int
    let ticketCode: String?
}

enum RUTicketSyncError: LocalizedError {
    case invalidCredentials
    case networkError
    case parseFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Não foi possível entrar no Portal da UFRGS. Confira seu cartão/CPF e senha."
        case .networkError:
            return "Não foi possível conectar ao Portal da UFRGS. Tente novamente em instantes."
        case .parseFailed:
            return "Login realizado, mas não foi possível ler o saldo de tickets no Portal."
        }
    }
}

enum RUTicketSyncService {
    private static let loginURLString = "https://www1.ufrgs.br/sistemas/portal/login?Destino=ccd7f388f9a3e25ef6aff3b98c773f65"
    private static let ticketsURLString = "https://www1.ufrgs.br/RU/tru/tiquete/index"
    private static let destinoValue = "ccd7f388f9a3e25ef6aff3b98c773f65"
    
    static func fetchTicketsInfo(username: String, password: String) async throws -> RUTicketsInfo {
        let config = URLSessionConfiguration.ephemeral
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        config.timeoutIntervalForRequest = 20
        
        let session = URLSession(configuration: config)
        defer { session.finishTasksAndInvalidate() }
        
        guard let loginURL = URL(string: loginURLString),
              let ticketsURL = URL(string: ticketsURLString) else {
            throw RUTicketSyncError.networkError
        }
        
        // 1. Inicializa cookies de sessão na página de login
        var getLoginRequest = URLRequest(url: loginURL)
        getLoginRequest.httpMethod = "GET"
        _ = try? await session.data(for: getLoginRequest)
        
        // 2. Envia POST de autenticação
        var postRequest = URLRequest(url: loginURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        postRequest.setValue(loginURLString, forHTTPHeaderField: "Referer")
        
        let formFields: [(String, String)] = [
            ("Destino", destinoValue),
            ("Origem", "-"),
            ("Var1", ""),
            ("Var2", ""),
            ("usuario", username),
            ("senha", password),
            ("login", "")
        ]
        
        let bodyString = formFields
            .map { "\(formEncode($0.0))=\(formEncode($0.1))" }
            .joined(separator: "&")
        postRequest.httpBody = bodyString.data(using: .utf8)
        
        let (_, postResponse) = try await session.data(for: postRequest)
        guard let httpPostResponse = postResponse as? HTTPURLResponse,
              (200...399).contains(httpPostResponse.statusCode) else {
            throw RUTicketSyncError.networkError
        }
        
        // 3. Acessa a página Meus Tíquetes
        var ticketsRequest = URLRequest(url: ticketsURL)
        ticketsRequest.httpMethod = "GET"
        
        let (ticketsData, ticketsResponse) = try await session.data(for: ticketsRequest)
        guard let httpTicketsResponse = ticketsResponse as? HTTPURLResponse,
              (200...299).contains(httpTicketsResponse.statusCode) else {
            throw RUTicketSyncError.networkError
        }
        
        let html = decodeHTML(ticketsData)
        
        // Se caiu de volta na tela de login, as credenciais falharam ou exigiu nova validação
        if html.contains("Portal de Serviços - Login") || html.contains("name=\"pessoal\"") {
            throw RUTicketSyncError.invalidCredentials
        }
        
        return try parseTicketsInfo(from: html)
    }
    
    private static func parseTicketsInfo(from html: String) throws -> RUTicketsInfo {
        // Isola o bloco de Tíquetes disponíveis (#yw0) antes da tabela de Tíquetes utilizados (#yw2)
        let sectionHTML: String
        if let yw0Range = html.range(of: "id=\"yw0\"") {
            let afterYw0 = html[yw0Range.lowerBound...]
            if let yw2Range = afterYw0.range(of: "id=\"yw2\"") {
                sectionHTML = String(afterYw0[..<yw2Range.lowerBound])
            } else {
                sectionHTML = String(afterYw0)
            }
        } else {
            sectionHTML = html
        }
        
        let ticketCode = extractFirstTicketCode(from: sectionHTML)
        
        // Caso padrão: "Exibindo 1-20 de 29 resultados."
        let pattern = #"Exibindo\s+\d+\s*-\s*\d+\s+de\s+(\d+)\s+resultados?"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
            let nsRange = NSRange(sectionHTML.startIndex..<sectionHTML.endIndex, in: sectionHTML)
            if let match = regex.firstMatch(in: sectionHTML, options: [], range: nsRange),
               match.numberOfRanges > 1,
               let countRange = Range(match.range(at: 1), in: sectionHTML),
               let count = Int(sectionHTML[countRange]) {
                return RUTicketsInfo(availableCount: count, ticketCode: ticketCode)
            }
        }
        
        // Caso sem tíquetes disponíveis na tabela #yw0
        if sectionHTML.contains("class=\"empty\"") || sectionHTML.localizedCaseInsensitiveContains("Nenhum resultado encontrado") {
            return RUTicketsInfo(availableCount: 0, ticketCode: nil)
        }
        
        throw RUTicketSyncError.parseFailed
    }
    
    /// Extrai o código do primeiro tíquete disponível (ex.: "832483") da primeira célula da tabela #yw0.
    private static func extractFirstTicketCode(from sectionHTML: String) -> String? {
        let codePattern = #"<tbody>[\s\S]*?<tr[^>]*>\s*<td[^>]*>(\d+)</td>"#
        guard let regex = try? NSRegularExpression(pattern: codePattern, options: [.caseInsensitive]) else {
            return nil
        }
        let nsRange = NSRange(sectionHTML.startIndex..<sectionHTML.endIndex, in: sectionHTML)
        guard let match = regex.firstMatch(in: sectionHTML, options: [], range: nsRange),
              match.numberOfRanges > 1,
              let codeRange = Range(match.range(at: 1), in: sectionHTML) else {
            return nil
        }
        return String(sectionHTML[codeRange])
    }
    
    private static func decodeHTML(_ data: Foundation.Data) -> String {
        if let utf8 = String(data: data, encoding: .utf8) {
            return utf8
        }
        if let latin1 = String(data: data, encoding: .isoLatin1) {
            return latin1
        }
        return String(decoding: data, as: UTF8.self)
    }
    
    private static func formEncode(_ value: String) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+&=;:/?#")
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }
}
