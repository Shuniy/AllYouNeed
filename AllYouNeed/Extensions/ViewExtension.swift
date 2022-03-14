//
//  ViewExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import Foundation
import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
    
    public func modify<T, U>(if condition: Bool, then modifierT: T, else modifierU: U) -> some View where T: ViewModifier, U: ViewModifier {
        Group {
            //Applies a modifier to a view and returns a new view
            if condition {
                modifier(modifierT)
            } else {
                modifier(modifierU)
            }
        }
    }
}
