//
//  ChatMessage.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 6.05.2022.
//

import Foundation


struct ChatMessage : Identifiable , Decodable
{
    var id = UUID().uuidString
    var from : String
    var to : String
    var message : String
    var time: Date
}
