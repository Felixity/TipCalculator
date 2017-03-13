//
//  DataSource.swift
//  TipCalculator
//
//  Created by Laura on 11/10/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import Foundation

struct DataSource
{
    /* Division factor needed for tip calculation */
    static let DivisionFactor     = 100
    
    /* The min/max number of people that can split a bill */
    static let MinNumberOfPeople  = 1
    static let MaxNumberOfPeople  = 10
    
    /* Alert information */
    static let AlertTitle         = "Alert"
    static let AlertMessage       = "This will reset your settings to factory defaults."
    static let OkAlertButton      = "OK"
    static let CancelAlertButton  = "Cancel"
    
    /* The max value that can be choosed from the rating picker view */
    static let PickerViewMaxLimit = 100
    
    static let currencyMappingSymbols: [String : String] =
    [
        "$" : "en_US",
        "€" : "de_DE",
        "£" : "en_GB",
        "฿" : "th_TH",
        "₺" : "tr",
        "₱" : "fil_PH"
    ]
    
    static let settingsDefaultValues: [[String : String]] =
    [
        ["description"          : "Terrible Service",
         "defaultTippingRate"   : "8%",
         "pickerValues"         : ""],
        
        ["description"          : "Satisfactory Service",
         "defaultTippingRate"   : "10%",
         "pickerValues"         : ""],
        
        ["description"          : "Excellent Service",
         "defaultTippingRate"   : "15%",
         "pickerValues"         : ""],
        
        ["description"          : "Currency Symbol",
         "defaultTippingRate"   : "$",
         "pickerValues"         : "\(DataSource.currencyMappingSymbols.keys.joined(separator: ","))"]
    ]
    
    /* Constant values used to remember the bill amount across app restarts  */
    static let goBack10Minutes = -600
}
