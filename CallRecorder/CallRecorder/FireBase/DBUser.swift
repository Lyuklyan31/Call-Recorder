import Foundation

struct DBUser: Codable {
    let userId: String
    let dataCreated: Date?
    let phoneNumber: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.dataCreated = Date()
        self.phoneNumber = nil
    }
    
    init(
     userId: String,
     dataCreated: Date? = nil,
     phoneNumber: String? = nil
     
    ) {
        self.userId = userId
        self.dataCreated = dataCreated
        self.phoneNumber = phoneNumber
    }
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case dataCreated = "data_created"
        case phoneNumber = "phone_number"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dataCreated = try container.decodeIfPresent(Date.self, forKey: .dataCreated)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.dataCreated, forKey: .dataCreated)
        try container.encodeIfPresent(self.phoneNumber, forKey: .phoneNumber)
    }
}
