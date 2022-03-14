//
//  RefreshableView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RefreshableView<Content:View>: View {
    //MARK: PROPERTIES
    private var content:() -> Content
    private var refreshAction: () -> Void
    private let threshold:CGFloat = 50
    
    //MARK: Constructor
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.refreshAction = action
    }
    
    //MARK: BODY
    var body: some View {
        GeometryReader {
            geometry in
            
            ScrollView(showsIndicators: false) {
                Spacer()
                content()
                    .anchorPreference(key: OffsetPreferenceKey.self, value: .top, transform: {
                        geometry[$0].y
                    })//:anchorPreference
                    .onPreferenceChange(OffsetPreferenceKey.self) {
                        offset in
                        if offset > threshold {
                            refreshAction()
                        }//:if
                    }//:onPrefrenceChange
                HStack {
                    Spacer()
                }
                Spacer()
            }//:ScrollView
        }//:Geometry Reader
    }//:Body
}

//MARK: PREVIEW
struct RefreshableView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableView(action: {}, content: {Text("Testing?")})
    }
}
