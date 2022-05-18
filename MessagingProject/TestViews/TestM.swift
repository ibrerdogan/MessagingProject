//
//  TestM.swift
//  MessagingProject
//
//  Created by İbrahim Erdogan on 29.04.2022.
//

import Foundation
import Combine
import SwiftUI
class denemeClass : ObservableObject
{
    @Published var metin = ""
    @Published var sinked = ""
    private var subscriber = Set<AnyCancellable>()
    
   init()
    {
        $metin.sink { comp in
            switch comp
            {
            case .finished:
                self.sinked += "finish"
            }
        } receiveValue: { value in
            self.sinked = value
        }
        .store(in: &subscriber)

       // $metin.sink { met in
       //     print(met)
       //     self.sinked = met
       // }
       // .store(in: &subscriber)
         
    }
    
    
}
