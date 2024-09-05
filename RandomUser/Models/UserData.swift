//
//  UserData.swift
//  RandomUser
//  Use to decode api data
//  Created by David on 9/3/24.
//

/* Sample results
{
  "results": [
    {
      "gender": "female",
      "name": {
        "title": "mrs",
        "first": "isobel",
        "last": "singh"
      },
      "location": {
        "street": "3880 devon street",
        "city": "blenheim",
        "state": "auckland",
        "postcode": 60715,
        "coordinates": {
          "latitude": "68.1616",
          "longitude": "92.2684"
        },
        "timezone": {
          "offset": "+6:00",
          "description": "Almaty, Dhaka, Colombo"
        }
      },
      "email": "isobel.singh@example.com",
      "login": {
        "uuid": "7a8c6300-9ce1-4b83-902e-d2dd7de24a21",
        "username": "whiteswan238",
        "password": "bobbob",
        "salt": "X3hRFlKd",
        "md5": "a5a28b72f7c9dace0d50e9f94440814a",
        "sha1": "9e1a51a00c068878b5d508caa2cd1b056be8531a",
        "sha256": "0b964dbeaf5500750da40b98ea97f16dae2ad308f4f866fede9615d0d9943bb9"
      },
      "dob": {
        "date": "1989-07-21T17:09:31Z",
        "age": 35
      },
      "registered": {
        "date": "2015-10-03T16:11:48Z",
        "age": 8
      },
      "phone": "(891)-261-1766",
      "cell": "(489)-060-2578",
      "id": {
        "name": "",
        "value": null
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/women/45.jpg",
        "medium": "https://randomuser.me/api/portraits/med/women/45.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/45.jpg"
      },
      "nat": "NZ"
    }
  ]
}
 */

import Foundation

struct UserData: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    //let id: ID
    let picture: Picture
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int?
}

// MARK: - ID
//struct ID: Codable {
//    let name: String
//    let value: String
//}

// MARK: - Location
struct Location: Codable {
    let street, city, state: String
    //let postcode: Int?
}

// MARK: - Coordinates
//struct Coordinates: Codable {
//    let latitude, longitude: String
//}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, description: String
}

// MARK: - Login
struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}

