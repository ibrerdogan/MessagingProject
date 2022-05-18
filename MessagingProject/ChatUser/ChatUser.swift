//
//  ChatUser.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 27.04.2022.
//

import Foundation

struct ChatUser : Identifiable , Decodable{
    var id = UUID().uuidString
    var email : String
    var imageURL : String
    var username : String
    var active : Bool
}
