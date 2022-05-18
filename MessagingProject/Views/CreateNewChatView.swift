//
//  CreateNewChatView.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 6.05.2022.
//

import SwiftUI
import URLImage
struct CreateNewChatView: View {
    let didselect : (ChatUser) -> ()
    @State var chatUser = ChatUser(id: "", email: "", imageURL: "",username: "",active: false)
    @State var userid = ""
    @State var usermail = ""
    @State var showMessages = false;
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager : FirebaseModel
    @State var searchable = ""
    @State var loading = false
    var body: some View {
        NavigationView{
        ScrollView{
            if manager.userlisting {
                ProgressView().progressViewStyle(.automatic)
            }
            else
            {
                ForEach(manager.userList){ user in
                    if user.email != manager.user.email{
                        NavigationLink {
                            MessageListView(sendingUser: user, manager: manager)
                                .navigationBarHidden(true)
                        } label: {
                            HStack{
                                URLImage(URL(string: user.imageURL)!,
                                         empty: {
                                        Image(systemName: "person.fill").font(.system(size: 35))
                                        .padding(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                                        )
                                         },
                                         inProgress: { progress in
                                            ProgressView().progressViewStyle(.automatic)
                                         },
                                         failure: { error, retry in
                                        Image(systemName: "person.fill").font(.system(size: 35))
                                        .padding(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                                        )
                                         },
                                         content: { image, info in
                                            image
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50)
                                                .aspectRatio(contentMode: .fit)
                                                .padding(2)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                                                )
                                         })
                             
                                Text(user.email)
                                Spacer()
                            }
                            .padding(.horizontal,2)
                            Divider()
                                .padding(.vertical,2)
                        }


                       
                    }
                    }
                }
            }
        .searchable(text: $searchable)
            
        .navigationTitle("Add New Chat")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        }
        .onAppear(){
            manager.fetchUsers()
        }
        .fullScreenCover(isPresented: $showMessages) {
            MessageListView(sendingUser: ChatUser(id: userid, email: usermail, imageURL: "",username: "",active: false),manager: manager)
        }
        
    }
}

struct CreateNewChatView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewChatView(didselect: { User in
            print(User.email)
        },manager: FirebaseModel())
    }
}
