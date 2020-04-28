//
//  SignUp.swift
//  HMACS
//
//  Created by Tristan on 4/22/20.
//  Copyright © 2020 Tristan Van Hook. All rights reserved.
//

import SwiftUI

struct SignUp: View {
    
    @State var name:String = ""
    @State var email:String = ""
    @State var password:String = ""
    @State private var error = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var core:Core
    
    func signUp () {
        print("sign me up")
        error = false
        core.signUp(email: email, password: password) { (result,
            error) in
            if error != nil {
                print("\(String(describing: error))")
                self.error = true
            } else {
                self.email = ""
                self.password = ""
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section(header: Text("Account Information")){
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                    }
                }.navigationBarTitle("Sign Up")
                
                Button(action: {self.signUp()
                    self.core.isSetUp = true
                    self.presentationMode.wrappedValue.dismiss()
                    self.core.profile?.email = self.email
                }
                ) {
                    Text("Create Account")
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
