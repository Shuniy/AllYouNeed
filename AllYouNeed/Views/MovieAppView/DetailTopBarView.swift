//
//  DetailTopBarView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct DetailTopBarView: View {
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var title:String
    
    //MARK: BODY
    var body: some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .padding(12)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
            
            Spacer()
            
            Button {
               
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .padding(12)
            }
            .hidden()
        }
    }
}

//MARK: PREVIEW
struct DetailTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTopBarView(title: Binding.constant("Movie Title"))
    }
}
