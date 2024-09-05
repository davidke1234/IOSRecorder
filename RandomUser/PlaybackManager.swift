//
//  AudioPlaybackManager.swift
//  RandomUser
//
//  Created by David on 9/4/24.
//

import AVFoundation
import CoreData
import UIKit

class PlaybackManager {
    //static let shared = PlaybackManager()
    
    //Setup CoreData context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    public func playAudio(fileName: String) {
        print("In playAudio")
        let fetchRequest: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "fileName == %@", fileName)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let audioFile = results.first,
                  let audioData = audioFile.fileData else {
                print("** Audio file not found")
                return
            }
            print("audioFileType: \(type(of: audioData))")
            let audioPlayer = try AVAudioPlayer(data: audioData)
            print("** Trying to play...")
            audioPlayer.volume = 1.0
            if audioPlayer.prepareToPlay() {
                print("** prepared to play...")
                audioPlayer.play()
            }
            
            print("** played...")
        } catch {
            print("** Error fetching or playing audio file: \(error)")
        }
    }
}

