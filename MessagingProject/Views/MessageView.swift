//
//  MessageView.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 25.04.2022.
//

import SwiftUI
import URLImage
struct MessageView: View {
    @State var showmenu = false;
    @State var gearAnimation = false;
    @State var newMessageShow = false;
    @Environment(\.presentationMode) var presentationMode
    @State var username_set = false
    @ObservedObject var model : FirebaseModel
    @State var imageURL = "https://firebasestorage.googleapis.com/v0/b/messagingapp-4484d.appspot.com/o/MEDZrYW6b2fF2lYPeyxj8iFSJ4m2?alt=media&token=c90b1e77-95f5-453c-b67f-9fea12f90b8c"
    
    var body: some View {
        NavigationView{
            VStack {
                VStack{
                    HStack {
                        URLImage(URL(string: imageURL)!,
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
                                        .padding(1)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                                        )
                                 })

                        VStack(alignment:.leading,spacing: 3){
                            Text(model.user.username).font(.system(size: 20,weight: .bold))
                            HStack{
                                Circle().foregroundColor(.green)
                                    .frame(width: 10, height: 10)
                                Text("last message").font(.system(size: 14,weight: .light))
                                
                            }
                        }.padding(.leading,2)
                        Spacer()
                        Button {
                            withAnimation {
                                gearAnimation.toggle()
                            }
                            
                            showmenu.toggle()
                        } label: {
                            Image(systemName: "gear").font(.system(size: 25,weight: .bold))
                                .padding(.trailing,2)
                                .foregroundColor(Color(.label))
                                .rotationEffect(.radians(gearAnimation ? 3 : 0))
                        }

                    }
                }.padding()
                    .actionSheet(isPresented: $showmenu) {
                        .init(title:Text( "Settings"), message: Text("Sign Out"), buttons: [
                            .default(Text("Sing Out"), action: {
                                model.LogOut()
                                presentationMode.wrappedValue.dismiss()
                            }),
                            .default(Text("Cancel").font(.body), action: {
                                withAnimation {
                                    gearAnimation.toggle()
                                    //showmenu.toggle()
                                }
                               
                            })
                           
                            
                        ])
                    }
                ScrollView
                {
                    if model.userList.count > 0 {
                        ForEach(model.userList){user in
                            VStack(alignment:.leading) {
                                HStack {
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
                                    VStack(alignment:.leading){
                                        Text(user.username).font(.system(size: 20,weight: .bold))
                                        Text("last message").font(.system(size: 14,weight: .light))
                                    }.padding(.leading,2)
                                    Spacer()
                                    Text("22d")
                                        .padding(.trailing,10)
                                }
                                Divider()
                            }.padding()
                        }.padding(.horizontal,12)
                    } else {
                        HStack
                        {
                            Spacer()
                            Text("No user found")
                            Spacer()
                        }
                        
                    }
                   
                }
                .refreshable {
                    print("refresh")
                }
                .padding(.vertical,10)
                .overlay(alignment:.bottom) {
                    Button {
                        newMessageShow.toggle()
                    } label: {
                        HStack{
                            Spacer()
                            Text(" + new message").font(.system(size: 20)).bold()
                                .foregroundColor(.white)
                            Spacer()
                                
                        }.padding(.vertical)
                            .background(.primary)
                            .cornerRadius(30)
                            .padding(.horizontal)
                    }
                }
                
                

            }
            .fullScreenCover(isPresented: $newMessageShow, content: {
                CreateNewChatView(didselect: { ChatUser in
                    print(ChatUser.email)
                },manager: model)
            })
            .fullScreenCover(isPresented: $username_set, content: {
                //SettingsView(manager: model)
            })
            .onAppear(){
                if model.user.email != ""
                {
                    imageURL = model.user.imageURL
                }
                if model.user.username == ""
                {
                    username_set = true
                }
                
            }
            .navigationBarHidden(true)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(model: FirebaseModel())
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
