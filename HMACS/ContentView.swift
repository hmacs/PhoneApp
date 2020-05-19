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
    var expiration:String
}

struct ContentView: View {
    @EnvironmentObject var core:Core
    @State var setUp = false
    @State var product_id = ""
    @State var productName = ""
    @State var productExpirationDate = ""
    @State var addedProducts:[Product]
    @State var showSheet = false

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
                                Button(action: {
                                    self.product_id = thisProduct.id.uuidString
                                    self.productName = thisProduct.name
                                    self.productExpirationDate = thisProduct.expiration
                                    self.showSheet = true
                                    
                                }){
                                    HStack{
                                        
                                    Text("\(thisProduct.name) || \(thisProduct.expiration)")
                                        .frame(maxWidth:UIScreen.main.bounds.size.width)
                                        .foregroundColor(.white)
                                        .padding()
                                    }.background(Color.blue)
                                    .cornerRadius(40)
                                    .padding()
                                    
                                }.sheet(isPresented: self.$showSheet){
                                    VStack{
                                        Text("Modify Product - \(self.product_id)")
                                            .padding()
                                        TextField("Add a Product", text: self.$productName).padding()
                                        TextField("Expiration Date?", text: self.$productExpirationDate)
                                        .padding()
                                        HStack{
                                            Button(action: {
                                                //Will put update here
                                                
                                                let productDictionary = [
                                                    "name":self.productName,
                                                    "expiration":self.productExpirationDate
                                                ]
                                                
                                                let docRef = Firestore.firestore().document("product/\(self.product_id)")
                                                print("setting data")
                                                docRef.setData(productDictionary, merge: true){ (error) in
                                                    if let error = error {
                                                        print("error = \(error)")
                                                    } else {
                                                        print("data updated successfully")
                                                        self.showSheet = false
                                                        self.productName = ""
                                                        self.productExpirationDate = ""
                                                    }
                                                }
                                                
                                            }){
                                                Text("Update rating")
                                                .padding()
                                                    .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                                    .foregroundColor(.black)
                                                    .cornerRadius(5)
                                            }
                                            Button(action: {
                                                //Will put update here
                                                
                                                
                                            }){
                                                Text("Delete Product")
                                                .padding()
                                                    .background(Color.init(red: 1, green: 0.9, blue: 0.9))
                                                    .foregroundColor(.red)
                                                    .cornerRadius(5)
                                                
                                            }.padding()
                                        }
                                       
                                    }
                                }

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
                            let dates = documents.map { $0["expiration"]! }
                            
                            print(names)
                            print(dates)
                            
                            self.addedProducts.removeAll()
                            
                            for i in 0..<names.count {
                                self.addedProducts.append(Product(id: UUID(uuidString:documents[i].documentID) ?? UUID(),
                                    name: names[i] as? String ?? "Failed to get name",
                                    expiration: dates[i] as? String ?? "Failed to get date"))
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
