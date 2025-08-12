//
//  CircularProgressView.swift
//  Faltapp
//
//  Created by Leonel Ferraz Hernandez on 08/08/25.
//

import SwiftUI

struct CircularProgressView: View {
    
    var progress: Double
    
    var progressColor: Color{
        switch progress{
        case 0..<0.5: return .circularGreen
        case 0.5..<0.75: return .circularOrange
//        case 0.85..<1: return .circularRed
        default: return .circularRed
        }
    }
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(progressColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(Angle(degrees: 180))
                .animation(.easeInOut, value: progress)
        }
        .frame(width: 93, height: 93)
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.45)
    }
}
