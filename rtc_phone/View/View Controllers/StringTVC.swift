//
//  StringTVC.swift
//  rtc_phone
//
//  Created by Андрей Королев on 06.05.2022.
//

import UIKit

class StringTVC: UITableViewController {
    

    @IBAction func addTapped(_ sender: Any) {
        alertPlusString(name: "Add new string", placeholder: "Enter a new string...") { (string) in
            
            translateString(toTranslate: string, targetLang: "zh") { (string, error) in
                if let error = error {
                    print(String(describing: error))
                    return
                }
                print(string)
                let chineseString = string
                if chineseString == "" {
                    return
                }
                DispatchQueue.main.async {
                    self.strings.append(chineseString)
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    var strings: [String] = []
    var translations: [Int: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func report() {
        print("reporting for duty!")
        print(strings)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (strings.count == 0) {
            return 2
        }
        return strings.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (strings.count == 0) {
            print("lol lol")
            print(indexPath.row)
            if (indexPath.row == 0) {
                print("lol xd")
                let cell = tableView.dequeueReusableCell(withIdentifier: "stringCell", for: indexPath) as! StringCell
                cell.stringLabel.text = "找不到中文字符串！使用扫描仪或添加"
                cell.translationLabel.text = "Китайская строка не найдена! Используйте сканер или добавьте"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "playgroundCell", for: indexPath) as! EnterPlaygroundCell
                return cell
            }
        }
        if indexPath.row < strings.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stringCell", for: indexPath) as! StringCell
            // Configure the cell...
            
            let index = indexPath.row
            
            cell.stringLabel.text = strings[index]
            cell.translationLabel.text = ""
            var translated = ""
            translateString(toTranslate: strings[index], targetLang: "ru") { (string, error) in
                if let error = error {
                    print(String(describing: error))
                    return
                }
                print(string)
                translated = string
                DispatchQueue.main.async {
                    cell.translationLabel.text = translated
                    self.translations[index] = translated
                }
            }
            
            if cell.translationLabel.text == "" {
                let pinText = strings[index].toPinyin()
                cell.translationLabel.text = pinText
                self.translations[index] = pinText
            }
            print(strings[index])

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playgroundCell", for: indexPath) as! EnterPlaygroundCell
            return cell
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (strings.count == 0) {
            return false
        }
        if (indexPath.row == strings.count) {
            return false
        }
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            
            if (self.strings.count == 0) {
                return
            }
            
            let editingRow = self.strings[indexPath.row]
            
            if let index = self.strings.firstIndex(of: editingRow) {
                
                self.strings.remove(at: index)
                
            }
            
            tableView.reloadData()
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if strings.count == 0 {
            if segue.identifier == "chineseSegue" {
                let target = segue.destination as! TranslationVC
                target.myString = "找不到中文字符串！使用扫描仪或添加"
                target.passTranslation = "Китайская строка не найдена! Используйте сканер или добавьте"
            }
            
            if segue.identifier == "playgroundSegue" {
                let target = segue.destination as! ARPlaygroundViewController
                target.stringsToPlace = ["找不到中文字符串！使用扫描仪或添加"]
                target.translations = [0: "Китайская строка не найдена! Используйте сканер или добавьте"]
            }
        } else {
            if segue.identifier == "chineseSegue" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let target = segue.destination as! TranslationVC
                    //print(target.mainText.text)
                    let row = indexPath.row
                    print(target)
                    print(row)
                    print(strings)
                    print(strings[row])
                    target.myString = strings[row]
                    //target.passTranslation = 
                    //target.setupFields(chineseString: strings[row])
                }
            }
            
            if segue.identifier == "playgroundSegue" {
                let target = segue.destination as! ARPlaygroundViewController
                target.stringsToPlace = strings
                target.translations = translations
            }
        }
    }
}
