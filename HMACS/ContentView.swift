//
//  ContentView.swift
//  HMACS
//
//  Created by Tristan on 4/22/20.
//  Copyright © 2020 Tristan Van Hook. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var core:Core
    @State var setUp = false
    @State var productName = ""
    @State var productExpirationDate = ""

    var body: some View {
        VStack{
            
            if (core.isSetUp ?? false){
                
                VStack {
                    TextField("Add a Product", text: $productName).padding()
                    TextField("Expiration Date?", text: $productExpirationDate)
                        .padding()

                    ScrollView{
                        Text("This will be the ScrollView")
                    }.frame(width: UIScreen.main.bounds.size.width)
                        .background(Color.red)
                    Button(action: {
                        let productDictionary = [
                            "name":self.productName,
                            "expiration":self.productExpirationDate
                        ]

                        let docRef = Firestore.firestore().document("product/\(UUID().uuidString)")
                        print("setting data")
                        docRef.setData(productDictionary){ (error) in
                            if let error = error {
                                print("error = \(error)")
                            } else {
                                print("data uploaded successfully")
                                self.productName = ""
                                self.productExpirationDate = ""
                            }
                        }
                    }){
                        Text("Add Product")
                    }


                }
            }else{
                VStack {
                    FirstPage()
                    
                }
            }
        }.onAppear{self.core.listen()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
