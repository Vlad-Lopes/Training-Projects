//
//  ContentView.swift
//  VladCard
//
//  Created by Vlad Lopes on 28/04/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Vlad")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 175, height: 175)
                    .clipShape(Circle())
                    .overlay( Circle()
                        .stroke().stroke(Color .white, lineWidth: 5))
                
                Text("Vlad Lopes")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(.white)
                
                Text("iOS Developer")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                
                Divider()
                InfoView(image: "phone.fill", text: "+55-11 98216-1311")
                InfoView(image: "envelope.fill", text: "vlad@vladlopes.com.br")
            
            }
         
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

