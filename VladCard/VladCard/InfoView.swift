//
//  InfoView.swift
//  VladCard
//
//  Created by Vlad Lopes on 28/04/20.
//  Copyright © 2020 Vlad Lopes. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    let image: String
    let text: String
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.white)
                .frame(height: 50)
            HStack {
                Image(systemName: image)
                    .foregroundColor(.green)
                
                Text(text)
                    .font(.system(size: 22))
                
            }
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(image: "phone.fill", text: "Hello")
            .previewLayout(.sizeThatFits)
    }
}
