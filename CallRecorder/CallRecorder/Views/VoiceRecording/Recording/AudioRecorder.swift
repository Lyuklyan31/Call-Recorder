//
//  AudioRecorder.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {

    override init() {
        super.init()
        fetchRecording()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [RecordingDataModel]()
    
    var recording = false { ///recording = false: Логічна змінна, що позначає, чи триває зараз запис аудіо. Вона за замовчуванням встановлена як false.
        didSet {///didSet: Спеціальний обробник, який викликається після того, як змінна recording змінить значення. Тут при зміні змінної надсилається сповіщення інтерфейсу через objectWillChange.
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance() ///recordingSession: Створюється сеанс аудіо через AVAudioSession, який дозволяє керувати налаштуваннями звуку на пристрої.

        
        do {///do/try/catch: Блок для обробки помилок. У блоці do виконується код, що може викликати помилку. Якщо вона виникне, то блок catch обробляє її.
            try recordingSession.setCategory(.playAndRecord, mode: .default) ///recordingSession.setCategory(.playAndRecord, mode: .default): Встановлює категорію аудіо, що дозволяє як записувати, так і відтворювати звук.
            try recordingSession.setActive(true) ///recordingSession.setActive(true): Активує аудіо сесію.
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] ///  Отримує шлях до директорії документів користувача на пристрої.

        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a") /// Формує шлях для збереження аудіофайлу, використовуючи поточну дату як частину імені файлу.
        
        let settings = [ /// Налаштування для аудіозапису. Визначає формат аудіо (AAC), частоту дискретизації (12000 Гц), кількість каналів (1), та якість запису (висока).
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings) /// Створює екземпляр аудіозапису з заданими налаштуваннями.
            audioRecorder.record() /// Починає запис аудіо.
            recording = true /// Встановлює значення змінної recording на true, що позначає початок запису.
        } catch {
            print("Could not start recording")
        }
    }
    
    func fetchRecording() {///fetchRecording(): Оновлює список записаних аудіофайлів.
           recordings.removeAll()///recordings.removeAll(): Очищає масив recordings.
           let fileManager = FileManager.default///fileManager: Отримує екземпляр FileManager для роботи з файловою системою.
           let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]///documentDirectory: Шлях до директорії з документами.
           let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)///directoryContents: Масив файлів з цієї директорії.
           for audio in directoryContents {///for audio in directoryContents: Цикл, що створює новий об’єкт Recording для кожного аудіофайлу та додає його до масиву recordings.
               let recording = RecordingDataModel(fileURL: audio, createdAt: getFileDate(for: audio))
               recordings.append(recording)
           }
           recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending}) ///recordings.sort(): Сортує записи за датою створення.
           objectWillChange.send(self) ///objectWillChange.send(self): Повідомляє про зміни в об’єкті.
       }
    
    func resetRecording() {
        if recording {
            audioRecorder.stop()  // Зупиняємо запис
            
            // Видаляємо поточний файл запису
            let currentRecordingURL = audioRecorder.url // Отримуємо URL записаного файлу
            do {
                try FileManager.default.removeItem(at: currentRecordingURL) // Видаляємо файл
                print("Файл видалено: \(currentRecordingURL)")
            } catch {
                print("Не вдалося видалити файл: \(error)")
            }
            
            recording = false // Скидаємо статус запису
            fetchRecording() // Оновлюємо список записів
        }
    }
    
    func deleteRecording(urlsToDelete: [URL]) { /// deleteRecording(): Видаляє вибрані аудіофайли. urlsToDelete: Масив URL-адрес файлів, які треба видалити.
        for url in urlsToDelete { /// for url in urlsToDelete: Проходить по кожному URL і видаляє його через FileManager.
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecording() /// Після видалення файлів оновлюється список записаних файлів.
    }
}
