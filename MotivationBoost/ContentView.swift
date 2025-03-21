//
//  ContentView.swift
//  MotivationBoost
//
//  Created by MACBOOK PRO on 21/03/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox // Pour la vibration

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0.5...1),
            green: Double.random(in: 0.5...1),
            blue: Double.random(in: 0.5...1)
        )
    }
}

struct ContentView: View {
    @State private var message = "Appuie pour une dose de motivation !"
    @State private var isPressed = false
    @State private var gradientColors = [Color.purple, Color.blue]
    @State private var rotationAngle : Double = 0
    
    var soundEffect : AVAudioPlayer?
    
    
    let motivations = [
        "Tu es plus fort que tu ne le crois !",
        "Chaque ligne de code te rapproche de ton objectif !",
        "Ne lâche rien, tu construis quelque chose de grand !",
        "Les developpeurs changent le monde, et tu en fais partie !",
        "L'échec n'existe pas, c'est juste une étape vers la réussite."
    ]
    
    func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    /*func playSound() {
        if let soundURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            do {
                soundEffect = try AVAudioPlayer(contentsOf: soundURL)
                soundEffect?.play()
            } catch {
                print("Erreur lors de la lecture du son")
            }
        }
    }*/
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .animation(.easeInOut(duration: 3.0), value: gradientColors)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                        gradientColors = [Color.random(), Color.random()]
                    }
                }
            
            VStack {
                Text(message)
                    .font(.custom("Avenir", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .rotation3DEffect(
                        .degrees(rotationAngle),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.5), value: rotationAngle)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)){
                        message = motivations.randomElement()!
                    }
                    rotationAngle += 360

                    
                    //Vibration
                    triggerVibration()
                    //playSound()
                }) {
                    HStack {
                            Image(systemName: "bolt.fill") // Icône d'éclair
                                .foregroundColor(.yellow)
                            
                            Text("🔥 Boost moi !")
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(), value: isPressed)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1)
                                .onChanged { _ in isPressed = true }
                                .onEnded { _ in isPressed = false }
                        )
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
