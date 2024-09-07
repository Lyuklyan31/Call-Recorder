import SwiftUI
import AVFoundation

struct Waves: View {
    @EnvironmentObject var audioManager: WavesViewModel
   
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        // Градієнт, що починається від середини і тягнеться до самого низу
                        LinearGradient(
                            gradient: Gradient(colors: [.customPink.opacity(0.3), .backraundWhite]),
                            startPoint: .center,  // Початкова точка градієнта з середини
                            endPoint: .bottom     // Кінцева точка градієнта знизу
                        )
                        .mask(
                            Path { path in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let history = audioManager.amplitudeHistory
                                let step = width / CGFloat(history.count)
                                
                                let baseline = (height / 2) - 150 // Встановіть baseline на центрі
                                
                                path.move(to: CGPoint(x: 0, y: baseline))
                                
                                for i in 0..<history.count {
                                    let x = CGFloat(i) * step
                                    let amplitude = history[i] * 150 // Зменшено масштаб амплітуди для кращого вигляду
                                    let y = baseline - amplitude  // Висота лінії
                                    
                                    if i > 0 {
                                        let previousX = CGFloat(i - 1) * step
                                        let previousAmplitude = history[i - 1] * 150
                                        let previousY = baseline - previousAmplitude
                                        
                                        path.addQuadCurve(
                                            to: CGPoint(x: x, y: y),
                                            control: CGPoint(x: (previousX + x) / 2, y: (previousY + y) / 2)
                                        )
                                    }
                                }
                                
                                path.addLine(to: CGPoint(x: width, y: baseline))
                                path.addLine(to: CGPoint(x: width, y: height))  // Лінія до самого низу
                                path.addLine(to: CGPoint(x: 0, y: height))     // Повертаємося до початкової точки внизу
                                path.addLine(to: CGPoint(x: 0, y: baseline))    // Повертаємося до базової лінії
                                path.closeSubpath()  // Закриваємо шлях
                            }
                        )
                        .edgesIgnoringSafeArea(.all)  // Ігнорування Safe Area
                        
                        // Хвиля, накладена поверх градієнта
                        Path { path in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            let history = audioManager.amplitudeHistory
                            let step = width / CGFloat(history.count)
                            
                            let baseline = (height / 2) - 150 // Встановіть baseline на центрі
                            
                            path.move(to: CGPoint(x: 0, y: baseline))
                            
                            for i in 0..<history.count {
                                let x = CGFloat(i) * step
                                let amplitude = history[i] * 150 // Зменшено масштаб амплітуди для кращого вигляду
                                let y = baseline - amplitude  // Висота лінії
                                
                                if i > 0 {
                                    let previousX = CGFloat(i - 1) * step
                                    let previousAmplitude = history[i - 1] * 150
                                    let previousY = baseline - previousAmplitude
                                    
                                    path.addQuadCurve(
                                        to: CGPoint(x: x, y: y),
                                        control: CGPoint(x: (previousX + x) / 2, y: (previousY + y) / 2)
                                    )
                                }
                            }
                        }
                        .stroke(Color.customPink, lineWidth: 2)
                    }
                }
                .onAppear {
                    if audioManager.isActive == true {
                        audioManager.startMonitoring()
                    } else {
                        audioManager.stopMonitoring()
                    }
            }
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all) 
    }
}

#Preview {
    Waves()
        .environmentObject(WavesViewModel())
}
