//
//  FirebaseModel.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 27.04.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
class FirebaseModel : ObservableObject {
    
    @Published var user : ChatUser
    @Published var userList : [ChatUser] = []
    @Published var userlisting = false
    @Published var StatusMessage : String
    @Published var AuthDone : Bool
    @Published var AuthStart : Bool
    @Published var ErrorMessage : String
    @Published var SignOutDone : Bool
    @Published var chatMessages : [ChatMessage] = []
    @Published var messageCount = 0
    @Published var deleting = false
    let db = Firestore.firestore()
    private var auth = Firebase.Auth.auth()
    
    init(){
        
        user = ChatUser(id: "", email: "", imageURL: "",username: "",active: false)
        StatusMessage = ""
        ErrorMessage = ""
        AuthDone = false
        SignOutDone = false
        AuthStart = false
        self.fetchUsersSnapshot()
    }
    // create firebase auth user
    func CreateAccount(email : String, password : String, pickerData : Data?)
    {
        self.StatusMessage = ""
        self.ErrorMessage = ""
        var check = false
        if email != ""
        {
            if password != ""
            {
                if pickerData?.isEmpty != true{
                    check = true
                }
                
            }
        }
        
        if check{
            AuthStart = true
            StatusMessage = "Creation has started"
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.StatusMessage = error.localizedDescription
                    self.AuthStart = false
                    return
                }
                guard let res = result else { self.AuthStart = false; return}
                self.StatusMessage = "Creation Has Done For \(res.user.email ?? "")"
                self.UploadProfileImage(uuid: res.user.uid,pickerData: pickerData)
                
            }
        }
        else
        {
            self.StatusMessage = ""
            self.ErrorMessage = "email and password doesnt empty"
        }
        
    }
    
    func sendMessage(to : String,message : String)
    {
        let from = Firebase.Auth.auth().currentUser?.uid
        let data = ["id" : UUID().uuidString,
                    "from" : from ?? "",
                    "to" : to,
                    "message":message,
                    "time" : Timestamp()
        ] as [String : Any]
        db.collection("messages").document(from!).collection(to).document()
            .setData(data) { error in
                print(error?.localizedDescription as Any)
            }
        
        db.collection("messages").document(to).collection(from!).document()
            .setData(data) { error in
                print(error?.localizedDescription as Any)
            }
    }
    func deleteMessage(to : String,id : String)
    {
        let from = Firebase.Auth.auth().currentUser?.uid
        db.collection("messages").document(from!).collection(to).whereField("id", isEqualTo: id).getDocuments { snap, error in
            snap?.documents.forEach({ query in
                DispatchQueue.main.async {
                    query.reference.delete()
                }
               
                
            })
        }
        
    }
    @Published var listener : ListenerRegistration!
    func feltchMessages(to :String)
    {
        
        self.chatMessages.removeAll()
        let from = Firebase.Auth.auth().currentUser?.uid
        listener = db.collection("messages").document(from!).collection(to).order(by: "time").addSnapshotListener { SnapShot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            SnapShot?.documentChanges.forEach({ doc in
                if doc.type == .added
                {
                    print("added")
                    do {
                      try self.chatMessages.append(doc.document.data(as: ChatMessage.self)!)
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                else if doc.type == .modified
                {print("modified")
                    
                }
                else if doc.type == .removed
                {
                    print("removed")
                }
                
                
            })
        }
    }
    
    private func UploadProfileImage(uuid : String,pickerData : Data?)
    {
        self.StatusMessage = "Profile Picture Upload Has Started"
        let ref = Storage.storage().reference(withPath: uuid)
        guard let imageData = pickerData
        else{ self.AuthStart = false ; return}
        ref.putData(imageData, metadata: nil) { StorageData, error in
            if let error = error {
                self.AuthStart = false
                self.ErrorMessage = error.localizedDescription
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    self.AuthStart = false
                    self.ErrorMessage  = error.localizedDescription
                    return
                }
                self.StatusMessage = "succes to download"
                let imagePath = url?.absoluteString ?? ""
                self.InsertUserFirestore(profileImagePath: imagePath)
            }
        }
    }
    
    func fetchUsers()
    {
       self.userlisting = true
        //self.userList.removeAll()
        db.collection("User").getDocuments { DocumentSnapshot, error in
            if let error = error {
                self.ErrorMessage = error.localizedDescription
                return
            }
            DocumentSnapshot?.documents.forEach({ doc in
                do {
                    //try self.userList.append(doc.data(as: ChatUser.self)!)
                }
                catch
                {
                    print(error.localizedDescription)
                }
            })

        }
        self.userlisting = false
    }
    
    func fetchUsersSnapshot()
    {
        db.collection("User").whereField("active", isEqualTo: true).addSnapshotListener { Query, error in
            //self.userList.removeAll()
            var index = 0
            if let error = error {
                print(error.localizedDescription)
            }
            else
            {
                Query?.documentChanges.forEach({ doc in
                    if doc.type == .removed
                    {
                        self.userList.forEach { usr in
                            do{
                                let tempuser = try doc.document.data(as: ChatUser.self)?.id
                                if usr.id == tempuser
                                {
                                    self.userList.remove(at: index)
                                }
                            }
                            catch
                            {
                                
                            }
                            index += 1
                        }
                    }
                    else if doc.type == .added
                    {
                        do{
                            
                            try self.userList.append(doc.document.data(as: ChatUser.self)!)
                        }
                        catch
                        {
                            print("error mapping")
                        }
                    }
                    
                })
            }
        }
    }
    
    private func InsertUserFirestore(profileImagePath : String)
    {
        self.StatusMessage = "user information is saving"
        let data = [
            "id" : Auth.auth().currentUser?.uid ?? "",
            "email" : Auth.auth().currentUser?.email ?? "",
            "imageURL" : profileImagePath,
            "username" : "",
            "active" : true
        ] as [String : Any]
        
        self.user.id = Auth.auth().currentUser?.uid ?? ""
        self.user.email = Auth.auth().currentUser?.email ?? ""
        self.user.imageURL = profileImagePath
        self.user.username = ""
        self.user.active = false
        
        let db = Firestore.firestore()
        
        db.collection("User").document(self.user.email).setData(data) { error in
            if let error = error{
                self.AuthStart = false
                self.ErrorMessage = error.localizedDescription
                return
            }
           
        }
        self.getUserInfo(mail: auth.currentUser?.email ?? "")
        
    }
    
    func LogIn(email : String, password : String)
    {
        self.AuthStart = true
        self.StatusMessage = "Start Login"
        if (email != "" && password != "")
        {
            auth.signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.ErrorMessage = error.localizedDescription
                    self.StatusMessage = ""
                    self.AuthStart = false
                    return
                }
                else
                {   self.StatusMessage = "Login Done"
                    self.getUserInfo(mail: email)
                }
               
            }
        }
        else
        {
            self.ErrorMessage = "invalid email or password"
            self.AuthStart = false
        }
       
        
    }
    func activateUser(mail : String)
    {
        self.StatusMessage = "active user"
        db.collection("User").document(mail).updateData(["active" : true]) { err in
            if let err = err {
                print("active error \(err.localizedDescription)")
            }
        }
    }
    
    func updateUsername(mail : String,username : String)
    {
        db.collection("User").document(mail).updateData(["username" : username]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
    func deactivateUser(mail : String)
    {
        db.collection("User").document(mail).updateData(["active" : false]) { err in
            if let err = err {
                print("active error \(err.localizedDescription)")
            }
        }
    }
    
    private func getUserInfo(mail : String)
    {
        let db = Firestore.firestore()
        let docRef = db.collection("User").document(mail)
        self.StatusMessage = "cheking user info"
        docRef.getDocument(completion: { [self] DocumentSnapshot, error in
            if let error = error {
                self.ErrorMessage = error.localizedDescription
                self.AuthStart = false
                return
            }
            else
            {
                self.StatusMessage = "feltching datas"
                if let document = DocumentSnapshot {
                        do {
                            self.user = try document.data(as: ChatUser.self)!
                            self.StatusMessage = self.user.email
                            if (self.user.id != "" && self.user.email != "" && self.user.imageURL != "")
                            {

                                print(self.user.id)
                                print(self.user.email)
                                print(self.user.imageURL)
                                self.activateUser(mail: self.user.email)
                                self.StatusMessage = "every think OK :)"
                                self.AuthStart = false
                                self.AuthDone =  true
                            }
                        }
                        catch {
                            self.ErrorMessage = error.localizedDescription
                            self.AuthStart = false
                            print(error.localizedDescription)
                        }
                      }
               
            }
            
        })
       
        
      
       
        
        
    }
    
    func LogOut()
    {
        do{
            self.deactivateUser(mail: self.user.email)
            self.AuthStart = false
            self.AuthDone = false
            self.StatusMessage = ""
            self.ErrorMessage = ""
            try auth.signOut()
            
        }
        catch
        {
            print("error \(error.localizedDescription)")
        }
        
    }
    
}
