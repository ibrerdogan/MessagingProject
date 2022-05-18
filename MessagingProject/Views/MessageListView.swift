//
//  MessageListView.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 6.05.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
//firestore listener için iptal seçeneği mevcut.
//çıkıştan sonra bile listener çalışıyor.
//listenerRegistiration ile yapılabilir. addSnapshotListener buna atanır ve bu arkadaşı removeall yaparız
struct MessageListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var message = ""
    var sendingUser : ChatUser
    @ObservedObject  var manager : FirebaseModel
    var body: some View {
        NavigationView{
            VStack
            {
                ScrollView{
                    ScrollViewReader { proxy in
                        VStack {
                            ForEach(manager.chatMessages){i in
                                    if i.from == manager.user.id {
                                        HStack{
                                            Spacer()
                                            Text(i.message)
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(.blue)
                                                .cornerRadius(10)
                                                .padding(.horizontal)
                                                .padding(.vertical,2)
                                                .id(i.id)
                                                .contextMenu {
                                                    Button {
                                                        manager.deleteMessage(to: sendingUser.id, id: i.id)
                                                    } label: {
                                                        Text("Delete")
                                                            
                                                    }

                                                }
                                               
                                        }
                                    } else {
                                        HStack{
                                            Text(i.message)
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(.gray)
                                                .cornerRadius(10)
                                                .padding(.horizontal)
                                                .padding(.vertical,2)
                                                .id(i.id)
                                            Spacer()
                                               
                                    }
                                }
                            }
                            .onAppear(){
                                withAnimation(.easeOut(duration: 0.5)) {
                                    proxy.scrollTo(manager.chatMessages.last?.id,anchor: .bottom)
                                }
                            }
                        
                        }
                        .onReceive(manager.$chatMessages) { _ in
                            print("\(manager.chatMessages.count)")
                            withAnimation(.easeOut(duration: 0.5)) {
                                proxy.scrollTo(manager.chatMessages.last?.id,anchor: .bottom)
                            }
                        }
                       
                    }
                }.background(Color(white: 0.9))
                    .padding(.bottom,2)
                
                
                
                
                HStack(){
                    Image(systemName: "gear")
                        .font(Font.title)
                        .padding(.horizontal)
                        
                    TextField("Message", text: $message)
                        .multilineTextAlignment(.leading)
                        .lineLimit(100)
                        .padding(.vertical)
                    
                    Button {
                        
                        manager.sendMessage(to: sendingUser.id
                                            , message: message)
                        message = ""
                        
                        
                    } label: {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .padding()
                    }

                }
                .padding(.top,2)
            }
            .navigationTitle(sendingUser.email)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        manager.listener.remove()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }

                }
            }
           
        }
        .onAppear(){
            guard sendingUser.id != "" else {return}
            manager.feltchMessages(to: sendingUser.id)
        }
        
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(sendingUser: ChatUser(id: "", email: "", imageURL: "",username: "",active: false),manager: FirebaseModel())
    }
}
