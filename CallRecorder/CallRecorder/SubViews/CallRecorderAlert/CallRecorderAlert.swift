//
//  CallRecorderAlert .swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct CallRecorderAlert_: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 48)
                .frame(height: 484)
                .overlay {
                    VStack {
                        Text("Don’t forget to tap ‘add call’ and choose contact to you want to call")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(.primaryExtraDark)
                            .padding(.top, 24)
                            .padding(.horizontal)
                        
                        TabBarIphones(selectedTab: $selectedTab)
                        
                        SwipeProgress(selectedTab: $selectedTab)
                        .padding(.top, 24)
                        .padding(.bottom, 10)
                           
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(lineWidth: 2)
                                .frame(height: 56)
                                .foregroundColor(.customPink)
                                .overlay {
                                    Text("Close")
                                        .font(.system(size: 19, weight: .medium))
                                        .foregroundColor(.customPink)
                                }
                               
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
        }
        .padding()
    }
}

#Preview {
    CallRecorderAlert_()
}
