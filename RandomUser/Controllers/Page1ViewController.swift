//
//  ViewController.swift
//  RandomUser
//
//  Created by David on 9/3/24.
//

import UIKit

class Page1ViewController: UIViewController {
    
    var nextUser = UserModel(first: "",last: "",DOB: "",email: "",picture: "",gender: "")
   
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var DOB: UILabel!
    @IBOutlet weak var InfoView: UIView!

    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InfoView.backgroundColor = UIColor.white
        view.setOnClickListener {
            self.performSegue(withIdentifier: "goToRecorder", sender: self)
        }

        userManager.delegate = self
        userManager.fetchUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecorder" {
            let destinationVC = segue.destination as! Page2ViewController

            destinationVC.pictureUrl = self.nextUser.picture
            destinationVC.firstName = self.nextUser.first
            destinationVC.gender = self.nextUser.gender
            destinationVC.lastName = self.nextUser.last
            destinationVC.DOB = self.nextUser.DOB
        }
    }
}

extension Page1ViewController: UserManagerDelegate {
    
    //*** create the delegate func.  This can be implemented by swift after adding the interface(protocol)
    func didUpdateUser(_ userManager: UserManager, user: UserModel) {
        //use dispatch to only update when data is ready.
        DispatchQueue.main.async {
            self.Email.text = user.email
            let fullName = "\(user.first) \(user.last)"
            self.Name.text = fullName
            self.DOB.text = user.DOB
   
            self.nextUser = UserModel(first: user.first,last: user.last,DOB: user.DOB,email: user.email,picture: user.picture, gender: user.gender)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        //todo: show user something
    }
}







