//
//  RecordingDataModel.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import Foundation

struct RecordingDataModel {
    let fileURL: URL
    let createdAt: Date
    
    var fileName: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
}

