//
//  TipCalculatorSettings.swift
//  TipCalculator
//
//  Created by Laura on 11/9/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import Foundation

class TipCalculatorSettings
{
    var settingTitle    : String
    var settingDetail   : String
    var pickerValues    : [String] =
        {
            // Creates an empty Int array
            var intArray = [Int]()
            
            // Extends the array using a Range
            intArray += 1...DataSource.PickerViewMaxLimit
            
            // Add % after each element
            let percentagesArray = intArray.map({$0.description + "%"})
            
            return percentagesArray
        }()
    
    init(description: String, value: String, pickerValues: String)
    {
        self.settingTitle  = description
        self.settingDetail = value
        self.pickerValues  = pickerValues.isEmpty ? self.pickerValues : pickerValues.components(separatedBy: ",")
    }
}
