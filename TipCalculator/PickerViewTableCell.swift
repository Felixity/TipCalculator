//
//  PickerViewTableCell.swift
//  TipCalculator
//
//  Created by Laura on 11/11/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import UIKit
protocol RatingPickerDelegate
{
    func didSelectRating(sender: PickerViewTableCell, value: String)
}

class PickerViewTableCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource
{

    var cell: TipCalculatorSettings?
    {
        didSet { updateUI() }
    }
    
    var delegate: RatingPickerDelegate!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func updateUI()
    {
        if let _ = cell
        {
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return (cell?.pickerValues.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        /* Uses delegation to send the selected rating value to the SettingsTableViewController */
        delegate.didSelectRating(sender: self, value: (cell?.pickerValues[row])!)
        
        /* Stores into Standard UserDefaults the selected rating value */
        defaults.set((cell?.pickerValues[row])!, forKey: self.cell?.settingTitle ?? "")
        defaults.synchronize()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        /* Provides the picker view with the data it needs to construct itself */
        return NSAttributedString(string: (cell?.pickerValues[row])!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
}
