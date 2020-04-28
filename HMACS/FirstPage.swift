//
//  FirstPage.swift
//  HMACS
//
//  Created by Tristan on 4/22/20.
//  Copyright © 2020 Tristan Van Hook. All rights reserved.
//

import SwiftUI
import MessageUI

let numberString = "816-361-2676"

struct FirstPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            VStack{
                Image("HMLogo")
                    .padding(.top, 14.0)
                
                Spacer()
                            
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + numberString
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                    }) {
                        
                        Image("HMPhone")
                            
                }.frame(width: 120, height: 120)
                    .background(Color.red)
                    .cornerRadius(60)
                    .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    self.isShowingMailView.toggle()
                    }) {
                        Image("HMCalendar")
                            
                }.disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                }
                .frame(width: 120, height: 120)
                    .background(Color.red)
                    .cornerRadius(60)
                    .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 17.0)
                
                Spacer()
                
                NavigationLink(destination:
                    SignIn().navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)) {
                        
                    Text("Sign In")
                        
                }.frame(width: 300, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    .animation(.easeIn(duration: 10))
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                }
                
                NavigationLink(destination:
                    SignUp().navigationBarTitle("")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)) {
                    Text("Register")
                }.frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.top,20)
                    .foregroundColor(Color.white)
                    .padding(.bottom,30)
            }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
