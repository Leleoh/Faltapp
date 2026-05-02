import SwiftUI

struct TutorsView: View {
    let tutores = Tutor.mocks
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background da view para combinar com o app
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(tutores) { tutor in
                            TutorCardView(tutor: tutor)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Tutores UFRGS")
        }
    }
}

#Preview {
    TutorsView()
}
