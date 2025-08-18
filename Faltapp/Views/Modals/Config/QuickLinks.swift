//
//  QuickLinks.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 16/08/25.
//

import SwiftUI

struct QuickLinksView: View {
    private let links: [(title: String, url: String)] = [
        ("Cardápio RU", "https://www.ufrgs.br/prae/cardapio-ru/"),
        ("Portal do Aluno", "https://www1.ufrgs.br/sistemas/portal/?Destino=ccd7f388f9a3e25ef6aff3b98c773f65"),
        ("E-mail UFRGS (Chasque)", "https://webmail.ufrgs.br/chasque/"),
        ("Calendário Escolar", "https://www.ufrgs.br/prograd/prograd/calendario-escolar/"),
        ("Mapas dos campus",
        "https://www.ufrgs.br/prograd/prograd/mapa-dos-campus"),
        ("TUAUFRGS", "https://www.ufrgs.br/tuaufrgs/"),
        ("Horários/Vagas de Cadeiras", "https://www1.ufrgs.br/graduacao/ArquivosCompartilhados/SelGrupoMatricula.php?tipo=gm&ret=../../graduacao/ArquivosCompartilhados/Horariosvagas.php")
    ]
    
    var body: some View {
        
            List {
                ForEach(links, id: \.url) { link in
                    Button(action: {
                        if let url = URL(string: link.url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text(link.title)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Links Rápidos")
            .background(Color(UIColor.backgroundsSecondary))
    }
}

#Preview {
    NavigationStack {
        QuickLinksView()
    }
}
