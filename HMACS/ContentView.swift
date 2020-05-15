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

struct Product: Identifiable {
    var id = UUID()
    var name:String
    var date:String
}

struct ContentView: View {
    @EnvironmentObject var core:Core
    @State var setUp = false
    @State var productName = ""
    @State var productExpirationDate = ""
    @State var addedProducts:[Product]

    var body: some View {
        VStack{
            
            if (core.isSetUp ?? false){
                
                VStack {
                    TextField("Add a Product", text: $productName).padding()
                    TextField("Expiration Date?", text: $productExpirationDate)
                    .padding()

                    ScrollView{
                        if addedProducts.count > 0 {
                            ForEach(addedProducts, id: \.id){ thisProduct in
                                Text("\(thisProduct.name) || \(thisProduct.date)")
                            }
                        }
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


                }.onAppear(){
                    
                    Firestore.firestore().collection("product")
                        .addSnapshotListener { querySnapshot, error in
                            guard let documents = querySnapshot?.documents else {
                                print("Error fetching documents: \(error!)")
                                return
                            }

                            let names = documents.map { $0["name"]! }
                            let dates = documents.map { $0["date"]! }
                            
                            print(names)
                            print(dates)
                            
                            
                            for i in 0..<names.count {
                                self.addedProducts.append(Product(
                                    name: names[i] as? String ?? "Failed to get name",
                                    date: dates[i] as? String ?? "Failed to get date"))
                            }
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
        ContentView(addedProducts: [])
    }
}
