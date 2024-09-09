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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtLastName: UILabel!
    @IBOutlet weak var personView: UIImageView!
    @IBOutlet weak var txtDOB: UILabel!
    @IBOutlet weak var txtFirstName: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    
    var audioFilesArray: [String] = []
    
    fileprivate func getRecordings() {
        print("Get recordings")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<AudioFile>(entityName: "AudioFile")
        
        do {
            print("In do..")
            let audioFiles = try context.fetch(fetchRequest)
            for audioFile in audioFiles {
                let fileName = audioFile.fileName!
                audioFilesArray.append(fileName)
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
        
        tableView.dataSource = self
        tableView.delegate=self
        tableView.isScrollEnabled=true;
        
        getRecordings()
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

extension Page3ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        audioFilesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = audioFilesArray[indexPath.row]
        return cell
    }
}

extension Page3ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
        let selectedCell = tableView.cellForRow(at: indexPath)
        let fileName = selectedCell?.textLabel?.text
        if let fileName = fileName {
            print("Playing \(fileName)")
            let playbackManager = PlaybackManager()
            playbackManager.playAudio(fileName: fileName)
        }
    }
}
