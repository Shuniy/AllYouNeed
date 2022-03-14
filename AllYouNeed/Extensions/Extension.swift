//
//  Extension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import Foundation
//MARK: DOUBLE
extension Double {
    func toString(places: Int = 1) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func convertToCelsius() -> String {
        let toCelsius = (self - 273.15).toString(places: 2)
        return "\(toCelsius)°C"
    }
}

//MARK: STRING
extension String {
    //Truncate string after maxlength
    func truncate(maxLength: Int, trailing: String = "...") -> String {
        if self.count <= maxLength {
            return self
        }
        var truncated = self.prefix(maxLength)
        while truncated.last != " " {
            truncated = truncated.dropLast()
        }
        return truncated + trailing
    }
    
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    //Convert to date
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        return date
    }
    
    //MARK: converts string, to date, and back to string
    func convertToStringDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    //MARK: REGEX
    public func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
}
