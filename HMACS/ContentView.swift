//
//  ContentView.swift
//  HMACS
//
//  Created by Tristan on 4/22/20.
//  Copyright © 2020 Tristan Van Hook. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var core:Core
    @State var setUp = false
    var body: some View {
        VStack{
            
            if (core.isSetUp ?? false){
                
                VStack {
                    Text("App Home Page")
                    Text("Welcome")
                    Text("Email: \(core.profile?.email ?? "")")
                    
                    
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
