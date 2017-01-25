//
//  SettingsTableCell.swift
//  TipCalculator
//
//  Created by Laura on 11/9/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell
{

    var cell: TipCalculatorSettings?
    {
        didSet { updateUI() }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func updateUI()
    {
        if let _ = cell
        {
            titleLabel.text = cell!.settingTitle
            detailLabel.text = cell!.settingDetail
        }
    }
}
