//
//  VoiceRecordingViewModel.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    
    @Published  var timerRecord: Timer?
    
    @Published  var seconds: Int = 0
    @Published  var minutes: Int = 0
    @Published  var timeString: String = "00:00"
    @Published var timerIsRunning: Bool = false
    
    func startTimer() {
        self.timerRecord?.invalidate()
        
        self.timerIsRunning = true
        timerRecord = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            self.seconds += 1
            
            if self.seconds == 60 {
                self.seconds = 0
                self.minutes += 1
            }
            
            let timeString = String(format: "%02d:%02d", minutes, self.seconds)
            self.timeString = timeString
        })
    }
    
    func stopTimer() {
        self.timerIsRunning = false
        self.timerRecord?.invalidate()
    }
    
    func resetTimer() {
        self.timerIsRunning = false
        self.timerRecord?.invalidate()
        self.seconds = 0
        self.minutes = 0
        
        let timeString = String(format: "%02d:%02d", minutes, self.seconds)
        self.timeString = timeString
    }
}
