//
//  CovidDataGroupBox.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 09/02/22.
//

import SwiftUI

struct CovidDataGroupBox: View {
    //MARK: PROPERTIES
    var covidDataType:CovidDataType
    @Binding var cases:[DailyModel]
    
    func convertDate(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateConverted = dateFormatter.date(from:date)!
        return dateConverted
    }
    
    //MARK: BODY
    var body: some View {
        GroupBox(label:
                    Label(covidDataType.text.uppercased(), systemImage: covidDataType.image).padding(.vertical)
                    .foregroundColor(covidDataType.color)) {
            
                        ForEach(0..<cases.count, id:\.self) {index in
                HStack {
                    Image(systemName: "hourglass.tophalf.filled")
                        .foregroundColor(covidDataType.color)
                    Text("\(convertDate(date: cases[index].day))")
                        .font(.caption2)
                    Spacer()
                    Group {
                        Text("\(cases[index].cases)")
                        Image(systemName: "eye.circle.fill")
                      
                    }//Group
                    .foregroundColor(covidDataType.color)
                }//:HStack
                .padding(.bottom, 5)
            }//:ForEach
        }//:GroupBox
                    .padding()
                    .cornerRadius(15)
                    .shadow(color: covidDataType.color, radius: 5, x: 0, y: 0)
    }//:Body
}

//MARK: PREVIEW
struct CovidDataGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        CovidDataGroupBox(covidDataType: CovidDataType.cases, cases: Binding.constant([DailyModel(id: 5, day: "2/8/22", cases: 504062), DailyModel(id: 7, day: "2/7/22", cases: 504062)]))
            .previewLayout(.sizeThatFits)
    }
}
