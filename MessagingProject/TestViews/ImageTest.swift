//
//  ImageTest.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 26.04.2022.
//

import SwiftUI
import URLImage

struct ImageTest: View {
    let imageURL = "https://firebasestorage.googleapis.com/v0/b/messagingapp-4484d.appspot.com/o/MEDZrYW6b2fF2lYPeyxj8iFSJ4m2?alt=media&token=c90b1e77-95f5-453c-b67f-9fea12f90b8c"
    var body: some View {
        VStack{
            URLImage(URL(string: imageURL)!,
                     empty: {
                        Image(systemName: "person.fill")
                     },
                     inProgress: { progress in
                        ProgressView().progressViewStyle(.automatic)
                     },
                     failure: { error, retry in
                        Image(systemName: "person.fill")
                     },
                     content: { image, info in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .padding(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                            )
                     })
        }
    }
}

struct ImageTest_Previews: PreviewProvider {
    static var previews: some View {
        ImageTest()
    }
}
