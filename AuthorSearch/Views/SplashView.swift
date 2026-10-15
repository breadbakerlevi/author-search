//
//  SplashView.swift
//  AuthorSearch
//
//

// View for Splash Screen with animation and transition to MainTabView

import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var pulse = false
    @State private var splashOpacity = 1.0
    
    let appName = "Author Search"
    
    var body: some View {
        ZStack {
            if showSplash == false {
                MainTabView()
                    .transition(.opacity)
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        ZStack {
                            Circle()
                                .stroke(.orange, lineWidth: 5)
                                .frame(width: 260, height: 260)
                            
                            Text("📚")
                                .font(.system(size: 180))
                                .scaleEffect(pulse ? 1.2 : 0.8)
                        }
                        
                        Text(appName)
                            .font(.title)
                            .fontWeight(.bold)
                            .wordArtStyle()
                    }
                    .opacity(splashOpacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(.easeInOut(duration: 0.5).delay(5.0)) {
                splashOpacity = 0
            }
            withAnimation(.linear.delay(5.0)) {
                showSplash = false
            }
        }
    }
}

struct WordArtModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink],
                             startPoint: .leading, endPoint: .trailing)
            )
            .shadow(color: .black, radius: 1, x: 3, y: 3)
    }
}

extension View {
    func wordArtStyle() -> some View {
        self.modifier(WordArtModifier())
    }
}

#Preview {
    SplashView(showSplash: .constant(true))
}
