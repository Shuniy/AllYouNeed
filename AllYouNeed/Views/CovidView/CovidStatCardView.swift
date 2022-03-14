//
//  CovidStatCardView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import SwiftUI

//MARK: COVID DATA TYPE ENUM
enum CovidDataType {
    case cases
    case deaths
    case recovered
    case critical
    case active
    
    var color:Color {
        switch self {
        case .cases:
            return Color.red
        case .deaths:
            return Color.purple
        case .recovered:
            return Color.green
        case .critical:
            return Color.blue
        case .active:
            return Color.indigo
        }
    }
    
    var image:String {
        switch self {
        case .cases:
            return "cross.fill"
        case .deaths:
            return "bolt.heart.fill"
        case .recovered:
            return "heart.fill"
        case .critical:
            return "waveform.path.ecg"
        case .active:
            return "allergens"
        }
    }
    
    var text:String {
        switch self {
        case .cases:
            return "Cases"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        case .critical:
            return "Critical"
        case .active:
            return "active"
        }
    }
}

struct CovidStatCardView: View {
    //MARK: PROPERTIES
    @Binding var value: Int
    var covidDataType:CovidDataType
    var percentage: Double?
    
    //MARK: BODY
    var body: some View {
        LazyVStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total \(covidDataType.text)".uppercased())
                        .font(.system(size: 15))
                    Text("\(value)")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                }//:VStack
                Spacer()
                Image(systemName: covidDataType.image)
                    .font(.system(size: 40))
                    .foregroundColor(covidDataType.color)
            }//:HStack
            .padding()
            Divider()
            if percentage != nil {
                HStack {
                    if percentage! <= 0 {
                        Text("\(abs(percentage!))% decrease from yesterday!")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .background(covidDataType == .recovered ? Color.red : Color.green)
                    } else {
                        Text("\(abs(percentage!))% increase from yesterday!")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .background(covidDataType == .recovered
                                        ? Color.green : Color.red)
                    }
                }//:HStack
                .padding()
            }//:If
        }//:LazyVStack
        .cornerRadius(20)
        .background(Color("Peach"))
        .foregroundColor(Color("Dark Purple"))
        .padding()
        .shadow(color: covidDataType.color, radius: 5, x: 0, y: 0)
    }//:Body
}

//MARK: PREVIEW
struct CovidStatCardView_Previews: PreviewProvider {
    static var previews: some View {
        CovidStatCardView(value: Binding.constant(200000), covidDataType: .cases, percentage: 2)
            .previewLayout(.sizeThatFits)
    }
}
