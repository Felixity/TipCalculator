//
//  TipViewController.swift
//  TipCalculator
//
//  Created by Laura on 11/9/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate, DataSourceDelegate
{

    @IBOutlet weak var billField:                   UITextField!
    
    @IBOutlet weak var tipLabel:                    UILabel!
    @IBOutlet weak var onePersonBillLabel:          UILabel!
    @IBOutlet weak var totalLabel:                  UILabel!
    @IBOutlet weak var numberOfPeopleLabel:         UILabel!
    
    @IBOutlet weak var terribleServiceButton:       UIButton!
    @IBOutlet weak var satisfactoryServiceButton:   UIButton!
    @IBOutlet weak var excellentServiceButton:      UIButton!
    
    var currentServiceRate:     Double?
    var currentServiceTitle:    String?
    
    let defaults = UserDefaults.standard
    
    private let background = CAGradientLayer().createGradientColor()
    
    private var ratingButtonsArray = [UIButton]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.billField.becomeFirstResponder()
        
        background.frame = self.view.bounds
        
        billField.delegate = self
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore
        {
            initFirstLaunch()
        }
        
        /* Initialize currentServiceRate and currentServiceTitle */
        let storedRate      = defaults.object(forKey: DataSource.settingsDefaultValues[0]["description"]!) as! String
        currentServiceRate  = Double(storedRate.replacingOccurrences(of: "%", with: ""))!
        currentServiceTitle = DataSource.settingsDefaultValues[0]["description"]
        
        ratingButtonsArray = [terribleServiceButton, satisfactoryServiceButton, excellentServiceButton]
        
        /* Initialize tipLabel, onePersonBillLabel and totalLabel */
        calculateTip()
        
        self.view.layer.insertSublayer(background, at: 0)
    }
    
    func initFirstLaunch()
    {
        /* First launch, initialize settingDetail to factory defaults */
        UserDefaults.standard.set(true, forKey: "launchedBefore")

        for cellData in DataSource.settingsDefaultValues
        {
            defaults.set(cellData["defaultTippingRate"], forKey: cellData["description"]!)
        }
        defaults.synchronize()
    }
    
    @IBAction func setNumberOfPeople(_ sender: UIButton)
    {
       if let operation = sender.currentTitle
       {
        var numberOfPeople = Int(numberOfPeopleLabel.text!) ?? 1
        let minNumberOfPeople = DataSource.MinNumberOfPeople
        let maxNumberOfPeople = DataSource.MaxNumberOfPeople
        
        switch operation
        {
        case "-":
            numberOfPeople = (numberOfPeople > minNumberOfPeople) ? numberOfPeople -  1 : minNumberOfPeople
        case "+":
            numberOfPeople = (numberOfPeople < maxNumberOfPeople - 1) ? numberOfPeople +  1 : maxNumberOfPeople
        default:
            break
        }
        numberOfPeopleLabel.text = String(numberOfPeople)
        calculateTip()
        view.endEditing(true)
       }
    }
    
    @IBAction func onTap(_ sender: Any)
    {
         view.endEditing(true)
    }
  
    @IBAction func calculateTip(_ sender: Any)
    {
        calculateTip()
    }
    
    func calculateTip()
    {
        let formatter         = NumberFormatter()
        /* Converts a string with comma separator to double */
        let bill              = formatter.number(from: billField.text!)?.doubleValue
        
        formatter.numberStyle = .currency
        let currentCurrency   = defaults.object(forKey: (DataSource.settingsDefaultValues.last?["description"])!) as! String
        formatter.locale      = Locale(identifier: DataSource.currencyMappingSymbols[currentCurrency]!)

        if bill != nil
        {
            let tip                 = bill! * currentServiceRate! / Double(DataSource.DivisionFactor)
            tipLabel.text           = formatter.string(from: NSNumber(value: tip))
            
            let total               = bill! + tip
            totalLabel.text         = formatter.string(from: NSNumber(value: total))
            
            let personalBill        = total / (Double(numberOfPeopleLabel.text!) ?? Double(DataSource.MinNumberOfPeople))
            onePersonBillLabel.text = formatter.string(from: NSNumber(value: personalBill))
        }
        else
        {
            tipLabel.text           = formatter.string(from: NSNumber(value: 0))
            totalLabel.text         = formatter.string(from: NSNumber(value: 0))
            onePersonBillLabel.text = formatter.string(from: NSNumber(value: 0))
        }
    }
    
    @IBAction func rateService(_ sender: UIButton)
    {
        setNewRateService(serviceTitle: DataSource.settingsDefaultValues[ratingButtonsArray.index(of: sender)!])
        calculateTip(sender)
        
        view.endEditing(true)
    }
    
    func setNewRateService(serviceTitle: [String : String])
    {
        let storedRate = defaults.object(forKey: serviceTitle["description"]!) as! String
        currentServiceRate = Double(storedRate.replacingOccurrences(of: "%", with: ""))!
        currentServiceTitle = serviceTitle["description"]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        textField.text?.removeLeadingZeros(newDigit: string)
        textField.text?.addZeroAsPrefix()
        
        var replacementText = textField.text ?? ""
        replacementText = replacementText.appending(string)
        
        return replacementText.isNumberValid(maximumFractionDigits: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.text?.addZeroAsPrefix()
        textField.text?.addZeroAsSufix()
    }
    
    func calculateNewTip()
    {
        let storedRate = defaults.object(forKey: currentServiceTitle!) as! String
        currentServiceRate = Double(storedRate.replacingOccurrences(of: "%", with: ""))!
        
        calculateTip()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showSettings"
        {
            let nextViewController = segue.destination as! SettingsTableViewController
            nextViewController.delegate = self
        }
    }    
}

extension String
{
    private static let decimalFormatter: NumberFormatter =
    {
            let formatter = NumberFormatter()
            formatter.allowsFloats = true
            return formatter
    }()
    
    private var decimalSeparator: String
    {
            return String.decimalFormatter.decimalSeparator ?? ","
    }
    
    private var componentsDividedBySeparator: [String]
    {
        return self.components(separatedBy: decimalSeparator)
    }
    
    mutating func removeLeadingZeros(newDigit: String)
    {
        /* Numbers like 08 are converted to 8 */
        if self.hasPrefix("0") && !newDigit.contains(decimalSeparator) && componentsDividedBySeparator.count == 1 /* means that no separator is found */
        {
            self.remove(at: self.startIndex)
        }
    }
    
    mutating func addZeroAsPrefix()
    {
        if self.hasPrefix(decimalSeparator)
        {
            self.insert("0", at: self.startIndex)
        }
    }
    
    mutating func addZeroAsSufix()
    {
        /* Checks against numbers like 23. and converts them to 23.00 by adding 0 at the end */
        if self.hasSuffix(decimalSeparator)
        {
            self.append("00")
        }
    }
    
    func isNumberValid(maximumFractionDigits: Int) -> Bool
    {
        guard self.isEmpty == false else
        {
            return true
        }
        
        /* Checks against numbers like 0.24.3.5 */
        let separatorOccurences = componentsDividedBySeparator.count - 1
        
        guard separatorOccurences > 1 else
        {
            let fractionalComponent = separatorOccurences == 1 ? componentsDividedBySeparator.last : ""
            
            /* If the user enters more than 2 decimal points, it will display only 2
             e.g. 32.345 will display 32.34 */
            return (fractionalComponent?.characters.count)! <= maximumFractionDigits
        }
        return false
    }
}
