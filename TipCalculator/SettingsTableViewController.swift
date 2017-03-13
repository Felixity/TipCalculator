//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by Laura on 11/9/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import UIKit

protocol DataSourceDelegate
{
    func calculateNewTip()
}

class SettingsTableViewController: UITableViewController, RatingPickerDelegate
{
    private struct Storyboard
    {
        static let CellReuseIdentifier = "settingsCell"
        static let PickerViewCellReuseIdentifier = "pickerViewCell"
    }
    
    var delegate: DataSourceDelegate?
    
    var pickerViewIndexPath: IndexPath?
    
    var pickerCellRowHeight: CGFloat?
    
    private let background = CAGradientLayer().createGradientColor()
    
    let defaults = UserDefaults.standard
    
    var cells: [TipCalculatorSettings] = []

    func initSettingTableCells()
    {
        for cellData in DataSource.settingsDefaultValues
        {            
            let cell = TipCalculatorSettings(description: cellData["description"]!, value: cellData["defaultTippingRate"]!, pickerValues: cellData["pickerValues"]!)
            self.cells.append(cell)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)

        tableView.separatorColor = UIColor.white
        
        initSettingTableCells()
        
        let pickerViewCellToCheck = tableView.dequeueReusableCell(withIdentifier: Storyboard.PickerViewCellReuseIdentifier)
       
        pickerCellRowHeight = pickerViewCellToCheck?.frame.size.height
        
        /* The settingDetail field needs to be set to last stored value */
        for cell in cells
        {
            cell.settingDetail = defaults.object(forKey: cell.settingTitle) as! String
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return (isPickerViewShown()) ? (cells.count + 1) : cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var tableCell :UITableViewCell
        if isPickerViewShown() && (pickerViewIndexPath?.row == indexPath.row)
        {
            tableCell = createPickerViewCell(indexPath: indexPath)
        }
        else
        {
            tableCell = createSettingDescriptionCell(indexPath: indexPath)
        }
        
        return tableCell
    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var rowHeigth = self.tableView.rowHeight
        if isPickerViewShown() && (pickerViewIndexPath?.row == indexPath.row)
        {
            rowHeigth = pickerCellRowHeight!
        }
        return rowHeigth
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /* BeginUpdates and endUpdates needes to be called to keep all the table updates together */
        tableView.beginUpdates()
        
        /* If the selected cell is the cell that triggered the picker view to be shown, then hide the picker view */
        if isPickerViewShown() && ((pickerViewIndexPath?.row)! - 1 == indexPath.row)
        {
            hideExistingPicker()
        }
        else
        {
            /* If the selected cell is a different, hide the current shown picker view and display a new one */
            let newIndexPath = calculateIndexPathForNewPicker(selectedIndexPath: indexPath)
            if isPickerViewShown()
            {
                hideExistingPicker()
            }
            showNewPickerAtIndex(indexPath: newIndexPath)
            pickerViewIndexPath = newIndexPath
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
    }
    
    func isPickerViewShown() -> Bool
    {
        return pickerViewIndexPath != nil
    }
    
    func hideExistingPicker()
    {
        tableView.deleteRows(at: [pickerViewIndexPath!], with: .fade)
        pickerViewIndexPath = nil
    }
    
    func calculateIndexPathForNewPicker(selectedIndexPath: IndexPath) -> IndexPath
    {
        /* If a picker view is already visible and is above the current selected row then we need to remember that the cell will be removed from the table and adjust the index accordingly  */
        if isPickerViewShown() && ((pickerViewIndexPath?.row)! < selectedIndexPath.row)
        {
            return selectedIndexPath
        }
        else
        {
            /* If it is below then it won't impact the new picker view index */
            return IndexPath(row: selectedIndexPath.row + 1, section: selectedIndexPath.section)
        }
    }
    
    func showNewPickerAtIndex(indexPath: IndexPath)
    {
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: indexPath.row, section: indexPath.section))
        tableView.insertRows(at: indexPaths, with: .fade)
    }
    
    func createSettingDescriptionCell(indexPath: IndexPath) -> SettingsTableCell
    {
        let descriptionCell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellReuseIdentifier, for: indexPath) as! SettingsTableCell
        descriptionCell.cell = cells[indexPath.row]
        return descriptionCell
    }
    
    func createPickerViewCell(indexPath: IndexPath) -> PickerViewTableCell
    {
        let pickerView = tableView.dequeueReusableCell(withIdentifier: Storyboard.PickerViewCellReuseIdentifier, for: indexPath) as! PickerViewTableCell
        pickerView.cell = cells[indexPath.row - 1]
        pickerView.delegate = self
        
        /* Sets the default value for the new created picker view to settingDetail */
        let index = cells[indexPath.row - 1].pickerValues.index(of: (cells[indexPath.row - 1].settingDetail))
        pickerView.pickerView.selectRow(index!, inComponent: 0, animated: false)
        
        
        return pickerView
    }
    
    func didSelectRating(sender: PickerViewTableCell, value: String)
    {
        cells[(pickerViewIndexPath?.row)! - 1].settingDetail = value
        
        /* Stores the new selected value */
        defaults.set(cells[(pickerViewIndexPath?.row)! - 1].settingTitle, forKey: value)
        defaults.synchronize()
        
        /* The row above the pickerView must be updated in order to display the new selected rating value */
        tableView.reloadRows(at: [IndexPath(row: (pickerViewIndexPath?.row)! - 1, section: (pickerViewIndexPath?.section)!)], with: .automatic)
    }
    
    
    @IBAction func showAlert(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: DataSource.AlertTitle, message: DataSource.AlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DataSource.OkAlertButton, style: .default, handler: { action in
            for component in DataSource.settingsDefaultValues
            {
                self.defaults.set(component["defaultTippingRate"], forKey: component["description"]!)
            }
            self.defaults.synchronize()
            
            for cell in self.cells
            {
                cell.settingDetail = self.defaults.object(forKey: cell.settingTitle) as! String
            }
            
            if self.isPickerViewShown()
            {
                self.tableView.beginUpdates()
                self.hideExistingPicker()
                self.tableView.endUpdates()
            }
            // Updates table
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: DataSource.CancelAlertButton, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func goBackToPreviousPage(_ sender: UIBarButtonItem) {
        guard (navigationController?.popViewController(animated: true) != nil)
        else
        {
            print("No Navigation Controller")
            return
        }
        delegate?.calculateNewTip()
    }
}
