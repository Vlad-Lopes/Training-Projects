//
//  ContentView.swift
//  Dicee-SwiftUI
//
//  Created by Vlad Lopes on 29/04/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var leftDiceNumber = 1
    @State var rightDiceNumber = 1
    
    var body: some View {
        ZStack {
            Image("background")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("diceeLogo")
                
                Spacer()
                HStack {
                    DiceView(n: leftDiceNumber)
                    DiceView(n: rightDiceNumber)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    self.leftDiceNumber = Int.random(in: 1...6)
                    self.rightDiceNumber = Int.random(in: 1...6)
                }) {
                    Text("Roll")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                }
                      .background(Color.red)
            }
        }
    }
}

struct DiceView: View {
    
    let n: Int
    var body: some View {
        Image("dice\(n)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

