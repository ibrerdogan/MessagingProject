//
//  ZstakDeneme.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 29.04.2022.
//

import SwiftUI
import Combine

struct ZstakDeneme: View {
    @State var deneme = false
    @State var giris = ""
    @State var test = ""
    @ObservedObject var objs = denemeClass()
    @State var width : CGFloat = 30
    var body: some View {
        ZStack {
            VStack(alignment:.leading)
            {
                if !deneme {
                    TextField("deneme", text: $giris).textFieldStyle(.roundedBorder)
                        .onChange(of: giris, perform: { newValue in
                        })
                        .padding()
                    TextField("deneme2", text: $test)
                        .onSubmit {
                            print("submit")
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    TextField("deneme2", text: $objs.metin)
                        .onSubmit {
                            print("submit")
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    
                }
                else
                {
                    ProgressView().progressViewStyle(.circular)
                }
                Button {
                    withAnimation {
                        deneme.toggle()
                    }
                    
                } label: {
                    Text("dokan")
                }
                
                Rectangle()
                    .foregroundColor(Color(#colorLiteral(red: 0.952919662, green: 0.4977704883, blue: 1, alpha: 0.71)))
                    .animation(.spring(), value: 1)
                    .frame(width: width, height: 30)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            if width == 30 {
                                width = 200
                            }
                            else
                            {
                                width = 30
                            }
                            
                        }
                    }
    
                   
                    

                
            }
            
        }
        
    }
}

struct ZstakDeneme_Previews: PreviewProvider {
    static var previews: some View {
        ZstakDeneme()
    }
}
