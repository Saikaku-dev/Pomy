//
//  HomeView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Image("colorful_tomato")
                .resizable()
                .scaledToFill()
                .frame(width: 300)
            Color.clear.opacity(0.1)
                .background(.ultraThinMaterial)
            
            Text("POMY")
            
            Text("")
        }
        .ignoresSafeArea(.all)
    }
}

extension Color {
    static var homeColor:Color {
        return Color(red: 251/255, green: 223/255, blue: 184/255)
    }
}

#Preview {
    HomeView()
}
