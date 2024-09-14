//
//  CountryCodeViewModel.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

class CountryCodeViewModel: ObservableObject {
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
}
