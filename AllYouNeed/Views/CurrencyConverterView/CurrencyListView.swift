//
//  CurrencyListView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 15/02/22.
//

import SwiftUI

struct CurrencyListView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel:CurrencyViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showCurrenciesSheet: Bool
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.currencies.sorted { $0.name < $1.name }.filter { !viewModel.showCurrencies.contains($0) }, id: \.code) { currency in
                    Button(action: {
                        viewModel.add(currency: currency)
                        showCurrenciesSheet.toggle()
                    }) {
                        Text(currency.name)
                    }
                }
            }
            .navigationTitle("Currencies")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("Close", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                })
            })//:Toolbar
        }//:navigationview
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView(viewModel: CurrencyViewModel(), showCurrenciesSheet: true)
//    }
//}
