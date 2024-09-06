//
//  CountryCode.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import Foundation

//MARK: - CountryCode

struct CountryCode: Codable {
    let countryCode: [CountryData]
}

struct CountryData: Codable {
    let name, flag, code, dialCode: String
    
    enum CodingKeys: String, CodingKey {
        case name, flag, code
        case dialCode = "dial_code"
    }
}
