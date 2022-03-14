//
//  CurrencyConverterView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI
import UIKit

struct CurrencyAppView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel = CurrencyViewModel.shared
    @State var currentCurrency: Currency = Currency.defaultCurrency
    @State var amount: String = "1"
    @State var showCurrenciesSheet: Bool = false
    private var rowHeight: CGFloat = 50
    @AppStorage("isDarkMode") private var isDarkTheme = false
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: FUNCTIONS
    private func lastUpdate() -> String {
        if let lastUpdate = viewModel.lastUpdate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: lastUpdate)
        }
        return ""
    }//:lastUpdate
    
    private func rateConvertion(to currency: Currency) -> String {
        if let amount = Double(amount) {
            return String(format: "%.2f", viewModel.convert(from: currentCurrency, to: currency, amount: amount))
        }
        return "-"
    }//:rateConversion
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                //MARK: Currency Selection
                Section() {
                    Picker(selection: $currentCurrency, label: Text(currentCurrency.code)) {
                        ForEach(viewModel.currencies.sorted { $0.name < $1.name }, id: \.code) { currency in
                            Text(currency.name)
                                .tag(currency)
                        }//:ForEach
                    }//:ForEach
                    TextField("Amount", text: $amount)
                        .font(.title)
                        .modifier(TextFieldClearButton(text: $amount))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(height: rowHeight)
                        .onChange(of: amount) { value in
                            viewModel.checkRatesExpiration()
                        }//:onChange
                    
                    
                }//:Section
                //MARK: LAST UPDATE
                Section() {
                    HStack {
                        Text("Last update:")
                        Spacer()
                        Text(lastUpdate())
                    }//:HStack
                    .font(.subheadline)
                }//:Section
                //MARK: SHOW CURRENCIES
                Section() {
                    ForEach(viewModel.showCurrencies, id: \.code) { currency in
                        HStack(alignment: .center, spacing: nil) {
                            VStack {
                                Text(currency.code)
                            }
                            Spacer()
                            Text(rateConvertion(to: currency))
                                .font(.title)
                        }//:HStack
                        .frame(height: rowHeight)
                    }//:ForEach
                    .onDelete(perform: viewModel.removeCurrency)
                    Button(action: { showCurrenciesSheet.toggle() }) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                                
                            Spacer()
                        }//:HStack
                    }//:Button
                }//:Section
            }//:form
            .navigationTitle("Currency Converter")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showCurrenciesSheet.toggle()
                    }, label: {
                        Text(Image(systemName: "plus"))
                    })
                })
                
                ToolbarItem (placement:ToolbarItemPlacement.navigationBarLeading){
                    Button(action: {
                        isDarkTheme.toggle()
                    }, label: {
                        isDarkTheme ? Label("Dark",systemImage: "lightbulb.fill"):
                        Label("Dark",systemImage:"lightbulb")
                        
                    })
                }
            })
        }//:Naviagtion View
        .environment(\.colorScheme,isDarkTheme ? .dark : .light)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(
            isPresented: $showCurrenciesSheet,
            content: {
                CurrencyListView(viewModel: viewModel, showCurrenciesSheet: $showCurrenciesSheet)
            })//:sheet
    }
}

//MARK: PREVIEW
struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyAppView()
    }
}
