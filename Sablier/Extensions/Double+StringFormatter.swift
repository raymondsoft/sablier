//
//  Double+StringFormatter.swift
//  Sablier
//
//  Created by etudiant-09 on 23/03/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation


extension Double {
    
    
    // return the double as String with N digits. If the conversion failed, then the standard String is returned.
    func toString(_ digits: Int) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = digits
        
        if let conversion = formatter.string(from: NSNumber(value: self)) {
            return conversion
        } else {
            return "\(self)"
        }
    }
}
