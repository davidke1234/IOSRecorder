//
//  RecordefViewController.swift
//  RandomUser
//
//  Created by David on 9/3/24.
//

import UIKit
import CoreData

class Page2ViewController: UIViewController {
    
    var nextUser = UserModel(first: "",last: "",DOB: "",email: "",picture: "",gender: "")
    
    @IBOutlet weak var personView: UIImageView!
    @IBOutlet weak var txtLastName: UILabel!
    @IBOutlet weak var txtFirstName: UILabel!
    @IBOutlet weak var txtDOB: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    
    @IBOutlet weak var BtnRecord: UIButton!
    @IBAction func record(_ sender: UIButton) {
        print("--ready to record...")
    }
    
    var pictureUrl = ""
    var gender = ""
    var firstName = ""
    var lastName = ""
    var DOB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //location where data is stored for this app
        print("**** Data stored at: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        setPicture(urlString: pictureUrl)
        txtLastName.text = lastName
        txtFirstName.text = firstName
        txtDOB.text = DOB
        txtGender.text = gender
    }

    @IBAction func nextPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPlayer", sender: self)
    }

    @IBAction func stop(_ sender: UIButton) {
        print("--stop recording and write to db")
        stopRecording(fileName: "David1")
    }
    
    fileprivate func setPicture(urlString: String) {
        //load picture
        let width = personView.frame.size.width
        personView.layer.cornerRadius = width / 2
        personView.clipsToBounds = true
        loadImage(from: urlString)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayer" {
            let destinationVC = segue.destination as! Page3ViewController

            destinationVC.pictureUrl = self.pictureUrl
            destinationVC.firstName = self.firstName
            destinationVC.gender = self.gender
            destinationVC.lastName = self.lastName
            destinationVC.DOB = self.DOB
        }
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
    
    func recordAudio() {
       RecorderManager.shared.startRecording()
    }

    func stopRecording(fileName: String){
        // Stop recording and save to Core Data
        // The manager will create the url path and disk filename, the fileName parma is friendly name, me thinks
        
        RecorderManager.shared.stopRecording()
        RecorderManager.shared.saveToCoreData(fileName: fileName)
    }
}
