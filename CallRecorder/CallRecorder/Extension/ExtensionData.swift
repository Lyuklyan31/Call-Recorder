//
//  ExtensionData.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

// Extension for formatting Date
import Foundation
import SwiftUI

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" 
        return dateFormatter.string(from: self)
    }
}

