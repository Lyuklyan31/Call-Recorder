import SwiftUI
import AVFoundation

struct WaveView: View {
    @EnvironmentObject var audioManager: WavesViewModel
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        // MARK: - Gradient Background
                        LinearGradient(
                            gradient: Gradient(colors: [.customPink.opacity(0.3), .backraundWhite]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .mask(
                            createWavePath(geometry: geometry, isGradient: true)
                        )
                        .edgesIgnoringSafeArea(.all)
                        
                        // MARK: - Wave Line
                        createWavePath(geometry: geometry, isGradient: false) 
                            .stroke(Color.customPink, lineWidth: 2)
                    }
                }
                .onAppear {
                    if audioManager.isActive {
                        audioManager.startMonitoring()
                    }
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Wave Path Drawing
    private func createWavePath(geometry: GeometryProxy, isGradient: Bool) -> Path {
        let width = geometry.size.width
        let height = geometry.size.height
        let history = audioManager.amplitudeHistory
        let step = width / CGFloat(history.count)
        let baseline = (height / 2) - 130
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: baseline))
            
            for i in 0..<history.count {
                let x = CGFloat(i) * step
                let amplitude = history[i] * (isGradient ? 150 : 150)
                let y = baseline - amplitude
                
                if i > 0 {
                    let previousX = CGFloat(i - 1) * step
                    let previousAmplitude = history[i - 1] * (isGradient ? -20 : -20)
                    let previousY = baseline - previousAmplitude
                    
                    path.addQuadCurve(
                        to: CGPoint(x: x, y: y),
                        control: CGPoint(x: (previousX + x) / 2, y: (previousY + y) / 2)
                    )
                }
            }
            
            if isGradient {
                path.addLine(to: CGPoint(x: width, y: baseline))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: baseline))
                path.closeSubpath()
            }
        }
    }
}

#Preview {
    WaveView()
        .environmentObject(WavesViewModel())
}
