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
//    let duration: TimeInterval
    
    var fileName: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
//    var formattedDuration: String {
//        let minutes = Int(duration) / 60
//        let seconds = Int(duration) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
}

