//
//  ExtensionData.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import Foundation

extension Date {
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
