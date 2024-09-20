//
//  ClipFrame.swift
//  CallRecorder
//
//  Created by Mac on 20.09.2024.
//

import SwiftUI

struct ClipFrame: View {
    @State private var offsetLeft = CGSize.zero
    @State private var offsetRight = CGSize.zero
    
//    @State private var lineWidth = CGSize.zero
    var body: some View {
        
        HStack {
            Rectangle()
                .frame(width: 24, height: 129)
                .cornerRadius(16, corners: [.topLeft, .bottomLeft])
                .foregroundColor(.blue)
                .overlay {
                    Image(.chevronLeft)
                }
                .offset(x: offsetLeft.width, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offsetLeft = gesture.translation
                        }
                )
                .offset(x: 8)
            
            Spacer()
            
            VStack {
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.blue)
            }
            .frame(height: 129)
            
            Spacer()
            
            Rectangle()
                .frame(width: 24, height: 129)
                .cornerRadius(16, corners: [.topRight, .bottomRight])
                .foregroundColor(.blue)
                .overlay {
                    Image(.chevronRight)
                }
                .offset(x: offsetRight.width, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offsetRight = gesture.translation
                        }
                )
                .offset(x: -8)
        }
        .padding()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    ClipFrame()
}
