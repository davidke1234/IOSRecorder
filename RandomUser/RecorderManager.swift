//
//  RecorderManager.swift
//  RandomUser
//
//  Created by David on 9/4/24.
//
// Data Stored at: (guids will change)
/*[/Users/<user>/Library/Developer/CoreSimulator/Devices/6500F834-7CAF-4081-B9CD-8F18EE0327D5/data/Containers/Data/Application/30BF21A4-55E6-4557-A6F7-752D298F036A/Library/Application Support]
 */

import UIKit
import AVFoundation

class RecorderManager: NSObject, AVAudioRecorderDelegate {
    //Setup for singleton pattern
    static let shared = RecorderManager()
    
    var audioRecorder: AVAudioRecorder?
    var audioFileURL: URL?
    
    //needed for singleton
    private override init() {
        super.init()
        setupRecorder()
    }
    
    private func setupRecorder() {
        print("** SetupRecorder")
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .default)
        try? audioSession.setActive(true)
        
        let fileName = UUID().uuidString + ".m4a"
        
        //fileURL is coming from the system
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        self.audioFileURL = fileURL
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            print("** Failed to set up audio recorder: \(error)")
        }
    }
    
    func startRecording() {
        print("** recording...")
        audioRecorder?.record()
    }
    
    func stopRecording() {
        print("** stop recording...")
        audioRecorder?.stop()
    }
}

//extension used for organization
extension RecorderManager {
    func saveToCoreData(fileName: String) {
        print("** Try saving to coreData")
        guard let fileURL = self.audioFileURL else { return }
        
        //Setup CoreData context
        let audioFile = AudioFile(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
        do {
            let audioData = try Data(contentsOf: fileURL)
            
            print("** fileName: \(fileName)")
            print("** fileData: \(audioData)")
            
            audioFile.fileName = fileName
            audioFile.fileData = audioData
            
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
            print("** Saved to CD")
        } catch {
            print("** Failed to save audio file to Core Data: \(error)")
        }
    }
}
