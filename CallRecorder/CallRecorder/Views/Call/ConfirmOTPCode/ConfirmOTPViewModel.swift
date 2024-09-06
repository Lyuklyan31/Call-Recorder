//
//  ConfirmOTPViewModel.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

final class ConfirmOTPViewModel: ObservableObject {
    
    @Published var remainingTime: Int = 60
    @Published var timer: Timer?
    @Published var timerIsRunning: Bool = false
    
    @Published var verificationID: String = ""
    @Published var phoneNumber: String = "+380"
    
    
    @Published var borderColor: Color = .black
    @Published var isTextFieldDisabled = false
    
    @Published var showResendText = false
    
    @Published var otpField = "" {
        didSet {
            guard otpField.count <= 6,
                  otpField.last?.isNumber ?? true else {
                otpField = oldValue
                return
            }
        }
    }
    
    func startTimer() {
        print("Starting timer...")
        self.stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.timerIsRunning = true
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                    print("Remaining time: \(self.remainingTime)")
                } else {
                    self.stopTimer()
                    self.timerIsRunning = false
                    self.remainingTime = 60
                    print("Timer stopped, resetting remaining time")
                }
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    var otp1: String {
        guard otpField.count >= 1 else {
            return ""
        }
        return String(Array(otpField)[0])
    }
    var otp2: String {
        guard otpField.count >= 2 else {
            return ""
        }
        return String(Array(otpField)[1])
    }
    var otp3: String {
        guard otpField.count >= 3 else {
            return ""
        }
        return String(Array(otpField)[2])
    }
    var otp4: String {
        guard otpField.count >= 4 else {
            return ""
        }
        return String(Array(otpField)[3])
    }
    var otp5: String {
        guard otpField.count >= 5 else {
            return ""
        }
        return String(Array(otpField)[4])
    }
    var otp6: String {
        guard otpField.count >= 6 else {
            return ""
        }
        return String(Array(otpField)[5])
    }
}
