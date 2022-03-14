//
//  TextFieldClearButton.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import SwiftUI

//MARK: CUSTOMTEXT FIELD
struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "delete.right")
                            .foregroundColor(Color(uiColor: UIColor.opaqueSeparator))
                    }
                )
            }
            //MARK: TEXT FIELD Content
            content
        }//:HStack
    }//:Body
}
