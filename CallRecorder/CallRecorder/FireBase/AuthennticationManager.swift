import Foundation
import FirebaseAuth
import AuthenticationServices

struct AuthDataResultModel {
    let uid: String
    let phoneNumber: String?
    
    init(user: User) {
        self.uid = user.uid
        self.phoneNumber = user.phoneNumber
    }
}


enum AuthProviderOption: String {
    case phoneNumber = "phone"
}


class AuthennticationManager: ObservableObject {
    
    @Published var userID: String? = UserDefaults.standard.string(forKey: "uid")
    
    static let shared = AuthennticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    
    //MARK: - GET PROVIDER
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        return providers
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "uid")
        self.userID = nil
    }
   
    func delete() async throws {
        guard let user = Auth.auth().currentUser  else {
            throw URLError(.badURL)
        }
        try await user.delete()
        UserDefaults.standard.removeObject(forKey: "uid")
        self.userID = nil
    }
}

//MARK: - Sign IN WITH PHONE

extension AuthennticationManager {
    @discardableResult
    func signInWithPhone(verificationID: String, verificationCODE: String) async throws -> AuthDataResultModel {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCODE)
        let authDataResult = try await Auth.auth().signIn(with: credential)
        let userID = authDataResult.user.uid
        UserDefaults.standard.set(userID, forKey: "uid")
        
        return AuthDataResultModel(user: authDataResult.user)
    }
}
