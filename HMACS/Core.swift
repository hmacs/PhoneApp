//
//  Core.swift
//  HMACS
//
//  Created by Tristan on 4/23/20.
//  Copyright © 2020 Tristan Van Hook. All rights reserved.
//

import Combine
import CloudKit
import Foundation
import FirebaseAuth
import SwiftUI
import UIKit
import MessageUI


class Core:ObservableObject{
    
    @Published var isSetUp:Bool?
    var didChange = PassthroughSubject<Core, Never>()
    var profile: Profile? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    let user = Auth.auth().currentUser
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.profile = Profile(id: user.uid, email: user.email!)
                
            } else {
                // if we dont have a user, set our session to nil
                self.profile = nil
            }
        }
    }
    
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
          print("Account Creation Successful")
        }
    }
    
    func logIn(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
          print("Account Creation Successful")
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func deleteAccount(){
        user?.delete{error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        }
    }
    
    func addName(name:String){
        profile?.name = name
    }
    
}

class Profile:ObservableObject{
    
    var id:String?
    var email:String?
    var password:String?
    var name:String?
    
    init(id:String, email:String){
        self.id = id
        self.email = email
    }
    
    func setProfileName(name:String){
        self.name = name
    }
    
    func getProfileName()->String{
        return self.name!
    }
    
}

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["kyle@heartlandmacs.com"])
        vc.setSubject("Book Appointment Request")
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
