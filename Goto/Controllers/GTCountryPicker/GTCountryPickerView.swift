//
//  GTCountryPickerView.swift
//  Goto
//
//  Created by Adrian Rusin on 1/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
@objc protocol GTCountryPickerViewDelegate {
    @objc optional func didSelectedCountry(pickerView: GTCountryPickerView, selectedCountry: GTCountry)
}

class GTCountryPickerView: UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!

    var delegate: GTCountryPickerViewDelegate?
    var countries = [String: [GTCountry]]()
    var arrayCountries = [GTCountry]()

    private var isSearchMode = false
    private var sectionsTitles = [String]()
    private var searchResults = [GTCountry]()
    var selectedCountry: GTCountry?
    private var currentLocationCountry: GTCountry?

    func configureCountryPickerView() -> GTCountry? {
        if countries.count == 0 {
            countries = getCountriesFromResource()
        }
        tableView.sectionIndexBackgroundColor = .clear
        tableView.sectionIndexTrackingBackgroundColor = .clear
        tableView.sectionIndexColor = .darkGray
        tableView.reloadData()
        
        return currentLocationCountry
    }
    func clearSearchText() {
        txtSearch.text = ""
        isSearchMode = false
        searchResults = []
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: true)
    }
    
    private func getCountriesFromResource() -> [String: [GTCountry]] {
        
        var countries = [GTCountry]()
        let path = Bundle(for: type(of: self)).path(forResource: "GTCountryCodes", ofType: "json")
        let dataJson = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        if let jsonResult = try? JSONSerialization.jsonObject(with: dataJson!, options: .mutableContainers) as? [[String: String]]
        {
            for json in jsonResult! {
                countries.append(GTCountry(json: json))
            }
        }
        arrayCountries = countries
        var header = Set<String>()
        countries.forEach{
            let name = $0.name
            header.insert(String(name![(name?.startIndex)!]))
        }
        
        var data = [String: [GTCountry]]()
        
        countries.forEach({
            let name = $0.name
            let index = String(name![(name?.startIndex)!])
            var dictValue = data[index] ?? [GTCountry]()
            dictValue.append($0)
            
            data[index] = dictValue
        })
        
        // Sort the sections
        data.forEach{ key, value in
            data[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            })
        }
        sectionsTitles = header.sorted()
        
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        currentLocationCountry = getCountryByCode(code!)
        selectedCountry = currentLocationCountry

        sectionsTitles.insert("Current Location", at: sectionsTitles.startIndex)
        data["Current Location"] = [currentLocationCountry!]
        
        sectionsTitles.insert("Selected", at: sectionsTitles.startIndex)
        data["Selected"] = [currentLocationCountry!]

        return data

    }
    public func getCountryByCode(_ code: String) -> GTCountry? {
        return arrayCountries.first(where: { $0.code == code })
    }

}
extension GTCountryPickerView : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDataSource, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : sectionsTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? searchResults.count : countries[sectionsTitles[section]]!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GTCountryTableViewCell
        let country = isSearchMode ? searchResults[indexPath.row] : countries[sectionsTitles[indexPath.section]]![indexPath.row]
        cell.configureCell(country: country)
        cell.accessoryType = .none
        if isSearchMode {
            cell.accessoryType = country == selectedCountry ? .checkmark : .none
        } else {
            cell.accessoryType = (country == selectedCountry && indexPath.row == 0 && indexPath.section == 0) ? .checkmark : .none
        }
        cell.separatorInset = .zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchMode ? nil : (section == 0 ? nil : sectionsTitles[section])
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchMode {
            return nil
        } else {
            return Array<String>(sectionsTitles.dropFirst(2))
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionsTitles.index(of: title)!
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = .clear
            header.textLabel?.text = header.textLabel?.text?.capitalized
            header.textLabel?.font = UIFont.systemFont(ofSize: 16)
            header.textLabel?.textColor = UIColor(red: 52.0 / 255.0, green: 63.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        endEditing(true)
        let country = isSearchMode ? searchResults[indexPath.row] : countries[sectionsTitles[indexPath.section]]![indexPath.row]
        var prevIndex : Int?
        if let index = searchResults.index(of: selectedCountry!) {
            prevIndex = index
        }
        clearSearchText()
        selectedCountry = country
        countries["Selected"] = [country]
        delegate?.didSelectedCountry!(pickerView: self, selectedCountry: country)
        if isSearchMode {
            if prevIndex != nil {
                tableView.reloadRows(at: [indexPath, IndexPath(row: prevIndex!, section: 0)], with: .automatic)
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}
extension GTCountryPickerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        isSearchMode = false
        if str.count > 0 {
            isSearchMode = true
            searchResults.removeAll()
            var indexArray = [GTCountry]()
            let prefix = String(str[str.startIndex]).uppercased()
            if let array = countries[prefix] {
                indexArray = array
            }
            
            searchResults.append(contentsOf: indexArray.filter({ $0.name.lowercased().hasPrefix(str.lowercased()) }))
        }
        tableView.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearSearchText()
        return true
    }
}
