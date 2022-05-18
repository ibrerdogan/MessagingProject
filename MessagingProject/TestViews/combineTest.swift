//
//  combineTest.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 9.05.2022.
//

import SwiftUI
import Combine
struct combineTest: View {
    @ObservedObject var tt = denemeClass()
    @State var metin = ""
    var body: some View {
        VStack{
            TextField("Metin", text: $tt.metin)
                .padding()
            Text(tt.sinked)
        }
       
    }
}

struct combineTest_Previews: PreviewProvider {
    static var previews: some View {
        combineTest()
    }
}
