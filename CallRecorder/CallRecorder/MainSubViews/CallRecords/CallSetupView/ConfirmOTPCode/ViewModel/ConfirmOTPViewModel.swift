//
//  ConfirmOTPViewModel.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

final class ConfirmOTPViewModel: ObservableObject {
    
    @Published var codeCountry = [CountryData]()
    
    init() {
      loadData()
    }
    
    func loadData() {
        guard let countryCodeData = Bundle.main.url(forResource: "countryCode", withExtension: "json") else {
            print("country.json file not found")
            return
        }
        
        let data = try? Data(contentsOf: countryCodeData)
        let code = try? JSONDecoder().decode([CountryData].self, from: data!)
        self.codeCountry = code!
    }
    
    @Published var remainingTime: Int = 60
    @Published var timer: Timer?
    @Published var timerIsRunning: Bool = false
    
    @Published var verificationID: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedDialCode: String = "+380"
    
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
    
    func sendVerificationCode(phoneNumber: String) async throws {
            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
            
           return try await withCheckedThrowingContinuation { continuation in
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let verificationID = verificationID else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    self.verificationID = verificationID
                    self.phoneNumber = phoneNumber
                    continuation.resume(returning: ())
                }
            }
        }
        
    func signIn() async throws {
            guard !otpField.isEmpty || !verificationID.isEmpty else {
                print("No verification or verificationID found")
                return
            }
        
            let authDataResult = try await AuthennticationManager.shared.signInWithPhone(verificationID: verificationID, verificationCODE: otpField)
            let user = DBUser(auth: authDataResult)
            
            do {
                if try await UserManager.shared.userExists(userId: user.userId) {
                    try await UserManager.shared.updateUser(user: user)
                } else {
                    try await UserManager.shared.createNewUser(user: user)
                }
                
                try await UserManager.shared.updateUserProfilePhoneNumber(userId: user.userId, phoneNumber: phoneNumber)
                
            } catch {
                print("Error saving user info to Firestore: \(error.localizedDescription)")
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
