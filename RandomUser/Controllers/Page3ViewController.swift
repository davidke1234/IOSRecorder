//
//  PlayViewController.swift
//  RandomUser
//
//  Created by David on 9/3/24.
//

import UIKit
import CoreData

class Page3ViewController: UIViewController {
    
    var pictureUrl = ""
    var gender = ""
    var firstName = ""
    var lastName = ""
    var DOB = ""
    

    @IBAction func GetRecordings(_ sender: UIButton) {
        getRecordings()
    }
    
    @IBOutlet weak var personView: UIImageView!
    @IBOutlet weak var txtLastName: UILabel!
    @IBOutlet weak var txtFirstName: UILabel!
    @IBOutlet weak var txtDOB: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    
    fileprivate func getRecordings() {
        print("Get recordings")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<AudioFile>(entityName: "AudioFile")
        
        do {
            print("In do..")
            let audioFiles = try context.fetch(fetchRequest)
            let playbackManager = PlaybackManager()
            for audioFile in audioFiles {
                let fileName = audioFile.fileName!
                    
                print("FileName: \(String(describing: audioFile.fileName))")
                playbackManager.playAudio(fileName: fileName)
            }
        } catch {
            print("Could not fetch audio files: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPicture(urlString: pictureUrl)
        txtLastName.text = lastName
        txtFirstName.text = firstName
        txtDOB.text = DOB
        txtGender.text = gender
        

    }
    
    fileprivate func setPicture(urlString: String) {
        //load picture
        let width = personView.frame.size.width
        personView.layer.cornerRadius = width / 2
        personView.clipsToBounds = true
        loadImage(from: urlString)
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a background thread for network operation
        DispatchQueue.global().async {
            do {
                // Fetch the image data
                let data = try Data(contentsOf: url)
                
                // Create a UIImage from the data
                if let image = UIImage(data: data) {
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.personView.image = image
                    }
                } else {
                    print("Unable to create image from data")
                }
            } catch {
                print("Failed to fetch image data: \(error)")
            }
        }
    }
    
    
}
