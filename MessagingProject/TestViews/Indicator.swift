//
//  Indicator.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 28.04.2022.
//

import SwiftUI

struct Indicator: View {
    var body: some View {
        VStack{
            ProgressView().progressViewStyle(.circular)
        }
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        Indicator()
    }
}
