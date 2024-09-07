//
//  UserManager.swift
//  RandomUser
//  Use to mangage User api data
//  Created by David on 9/3/24.
//

import Foundation

//*** create the protocol
protocol UserManagerDelegate {
    func didUpdateUser(_ userManager: UserManager, user: UserModel)
    func didFailWithError(error: Error)
}

struct UserManager {
    let userURL = "https://randomuser.me/api/1.2/?results=1"
    
//    A delegate in Swift is a design pattern that allows one class to delegate the execution of a specific task to an object within another class.  SET the delegate protocol to pass data to view controller
    var delegate: UserManagerDelegate?
    
    func fetchUser() {
        let urlString = "\(userURL)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. create the url
        if let url = URL(string: urlString) {
            //2. create url session
            let session = URLSession(configuration: .default)
            
            //3. give session a task, using a closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return  //exit out of func handle
                }
                
                //no errors, use optional binding to check data.  Set the delegate
                if let safeData = data {
                    if let user = self.parseJSON(safeData) {
                        // *** SET the delegate protocol to pass data to view controller
                        self.delegate?.didUpdateUser(self, user: user)
                    }
                }
            }
            
            //4. start the task
            //why resume?  Tasks begin in a suspended state
            task.resume()
        }
    }
    
    func parseJSON(_ userData: Data) -> UserModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UserData.self, from: userData)

            let first = decodedData.results[0].name.first
            let last = decodedData.results[0].name.last
            let email = decodedData.results[0].email
            let picture = decodedData.results[0].picture.large
            let gender = decodedData.results[0].gender
            
            //Get DOB
            var dob = ""
            let dateString = decodedData.results[0].dob.date
            let dateFormater = DateFormatter()
            //this date is zulu so use timezone UTC
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormater.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormater.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MM/dd/yyyy"
                dob = outputFormatter.string(from: date)
            }
 
            let userModel = UserModel(first: first, last: last, DOB: dob, email: email, picture: picture, gender: gender)
             
            return userModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


