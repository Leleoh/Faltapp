import Foundation

struct Tutor: Identifiable {
    let id = UUID()
    let nome: String
    let titulacao: String
    let materias: [String]
    let areaGeral: String
    let precoPorHora: String // Deixando String pra poder botar "A combinar" ou "Promoção"
    let biografia: String
    let telefone: String
    var imagemNome: String?
    
    // Mock Data
    static let mocks: [Tutor] = [
        Tutor(
            nome: "Gabriel Ribeiro Padilha",
            titulacao: "Mestre em Ensino de Matemática na UFRGS",
            materias: [
                "Cálculo I", "Cálculo II", "Álgebra Linear", "Equações Diferenciais",
                "Matemática Aplicada", "Métodos Aplicados I", "Métodos Aplicados II",
                "Prob. e Estatística", "Cálculo Numérico", "Matemática Discreta",
                "Física I - C", "Física - Eletromag.", "Química Fundamental", "Química Geral Teórica"
            ],
            areaGeral: "Exatas",
            precoPorHora: "A combinar",
            biografia: "Mais de 7 anos de experiência ajudando alunos a superarem desafios nas disciplinas de exatas. As aulas são focadas no seu objetivo, seja revisar conteúdos, aprender conceitos básicos ou aprofundar-se em temas específicos. Ofereço suporte na resolução de listas de exercícios, provas anteriores e esclarecimento de dúvidas pontuais. Condições especiais para turmas com 3 ou mais pessoas!",
            telefone: "5551989114039", // Formato internacional pro link do whats
            imagemNome: "gabriel"
        )
    ]
}
