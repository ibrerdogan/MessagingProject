//
//  SettingsView.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 9.05.2022.
//

import SwiftUI
import URLImage
import Combine
struct SettingsView: View {
    @StateObject var controller = UsernameCheck()
    @ObservedObject var manager : FirebaseModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            VStack{
                Image(systemName: "person.fill")
                    .font(.system(size: 150))
                    .padding()
                    .background {
                        Circle()
                            .stroke(lineWidth: 3)
                    }
            }
            .padding()
            HStack(alignment: .center){
                Text("Personel Information")
                    .font(.system(size: 20))
                    .padding()
            }
            VStack {
                Form{
                    Section {
                        TextField("Username", text: $controller.username)

                    } header: {
                        Text("Please Insert informations")
                    } footer: {
                        if controller.enable == false {
                            Text("username dont be empty")
                                .foregroundColor(.red)
                        }
                        else
                        {
                            EmptyView()
                        }
                        
                    }
                }
                .cornerRadius(20)
                .offset(y: -20)
                HStack(alignment:.center){
                    Button {
                        manager.updateUsername(mail: manager.user.email, username: controller.username)
                        manager.user.username = controller.username
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                       VStack
                        {
                            Text("Save")
                                .padding()
                                .foregroundColor(.white)
                                .background{
                                    RoundedRectangle(cornerRadius: 20).frame(width: 200, height: 50)
                                }
                                .padding()
                        }
                        .disabled(!controller.enable)
                        
                        
                    }

                }
               
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(manager: FirebaseModel())
    }
}
class UsernameCheck : ObservableObject{
    private var subscriber = Set<AnyCancellable>()
    @Published var username = ""
    @Published var enable = false
    init(){
        $username
            .receive(on: RunLoop.main)
            .sink { t in
            if t.count > 3 {
                self.enable = true
            }
            else
            {
                self.enable = false
            }
        }
        .store(in: &subscriber)
    }
    
    deinit
    {
        subscriber.removeAll()
        print("deinit")
    }
}
