//
//  LoginPage.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 25.04.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct LoginPage: View {
    
    @State var isCreation = true
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State var statusmessage = ""
    @State var showPicker = false
    @State var picker : UIImage?
    @State var imagePath = ""
  
    
    @ObservedObject var model = FirebaseModel()
    
    
    var body: some View {
        NavigationView{
           ScrollView
            {
                VStack {
                    Picker("Select Action", selection: $isCreation, content: {
                        Text("Log In")
                            .tag(false)
                        Text("Create Account")
                            .tag(true)
                    }).pickerStyle(.segmented)
                   
                      
                    
                    if isCreation {
                        VStack
                        {
                            Button {
                                showPicker.toggle()
                            } label: {
                               
                                if let image = self.picker{
                                    Image(uiImage: image)
                                        .resizable()
                                        .cornerRadius(64)
                                        .frame(width: 120, height: 120)
                              
                                }
                               else
                                {
                                    Image(systemName: "person.fill")
                                        .font(Font.system(size: 100))
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(){
                                            Circle().stroke(lineWidth: 2).foregroundColor(.black)
                                        }
                                }
                              
                            }

                        }
                        .padding(.vertical,20)
                    } else {
                        EmptyView()
                    }
                    
                    Group{
                        HStack{
                            Spacer()
                            TextField("email", text: $email)
                                .padding()
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                            Spacer()
                        }
                        .background(Color.white)
                        HStack{
                            SecureField("password", text: $password)
                            .padding()
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                        }
                        .background(Color.white)
                    }
                    .animation(.spring(), value: isCreation)
                    VStack{
                        Button {
                            if !model.AuthStart {
                                EventHandler()
                            }
                        } label: {
                            HStack{
                                Spacer()
                                if model.AuthStart {
                                    ProgressView().progressViewStyle(.circular)
                                        .foregroundColor(.white)
                                        .padding()
                                }else
                                {
                                    Text(isCreation ? "Create Account" : "Log In")
                                        .foregroundColor(.white)
                                        .padding(.vertical,20)
                                }
                                
                                Spacer()
                            }
                            .background(.blue)
                            .animation(.spring(),value: isCreation)
                            
                        }
                    }.padding(.vertical,20)

                    Text(model.ErrorMessage)
                        .foregroundColor(.red)
                        .animation(.easeInOut)
                    
                    Text(model.StatusMessage)
                        .foregroundColor(.blue)
                        .animation(.easeInOut)
                }.padding()
                
                
            }
            .background(Color(.init(gray: 0.2, alpha: 0.2)))
            .navigationTitle(isCreation ? "Create Account" : "Log In")
            
        }
       // .opacity(0.2)
       // .disabled(true)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showPicker, onDismiss: nil) {
            ImagePicker(image: $picker)
        }
        .fullScreenCover(isPresented: $model.AuthDone, onDismiss: nil) {
            MessageView(model: model)
        }
    }
    
    
    
    
    private func EventHandler()
    {
        if isCreation
        {
            model.CreateAccount(email: email.lowercased(), password: password, pickerData: self.picker?.jpegData(compressionQuality: 0.5))
           // statusmessage = "Start Creation"
           // FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) //result, authError in
           //     if authError == nil {
           //         print("Createion has done for \(result?.user.uid ?? "")")
           //         statusmessage = "Creation has done"
           //         self.uploadImage(uuid: (result?.user.uid)!)
           //     }
           //     else
           //     {
           //         errorMessage = authError?.localizedDescription ?? ""
           //     }
           // }
        }
        else
        {
            model.LogIn(email: email.lowercased(), password: password)
            //Auth.auth().signIn(withEmail: email, password: password) { result, signError in
            //    if signError == nil {
            //        print("Log In was succesful")
            //    }
            //    else
            //    {
            //        errorMessage = signError?.localizedDescription ?? ""
            //    }
            //}
        }
    }
    private func insertUser()
    {
        statusmessage = "user information is saving"
        let data = [
            "uuid" : Auth.auth().currentUser?.uid ?? "",
            "mail" : Auth.auth().currentUser?.email ?? "",
            "image" :imagePath
        ] as [String : Any]
        let mail = Firebase.Auth.auth().currentUser?.email ?? ""
        let db = Firestore.firestore()
        
        db.collection("User").document(mail).setData(data) { error in
            if let error = error{
                errorMessage = error.localizedDescription
            }
            statusmessage = "every think OK :)"
        }
       
    }
    
    private func uploadImage(uuid : String)
    {
        statusmessage = "Profile Picture Uploading has started"
        let ref = Storage.storage().reference(withPath: uuid)
        guard let imageData = self.picker?.jpegData(compressionQuality: 0.5)
        else{return}
        ref.putData(imageData, metadata: nil) { StorageData, error in
            if let error = error {
                print("put data error ")
                errorMessage = error.localizedDescription
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print("put data error ")
                    errorMessage = error.localizedDescription
                }
                print("succes to download",url?.absoluteURL ?? "")
                imagePath = url?.absoluteString ?? ""
                statusmessage = "Profile picture upload has done"
                self.insertUser()
            }
        }
        
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
