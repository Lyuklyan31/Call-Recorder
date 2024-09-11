//
//  Helper.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import Foundation


func getFileDate(for file: URL) -> Date? {
    let fileManager = FileManager.default
    do {
        let attributes = try fileManager.attributesOfItem(atPath: file.path)
        return attributes[.creationDate] as? Date
    } catch {
        print("Could not retrieve file attributes: \(error)")
        return nil
    }
}
