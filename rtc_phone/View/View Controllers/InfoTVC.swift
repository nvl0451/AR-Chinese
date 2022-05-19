//
//  InfoTVC.swift
//  rtc_phone
//
//  Created by Андрей Королев on 12.05.2022.
//

import UIKit

class InfoTVC: UITableViewController {
    
    var initString: String = ""
    
    var chineseKeys: [String] = []
    var englishKeys: [String] = []
    var tagValues: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func decomposeInitString() {
        print("decomposing \(initString)...")
        
        let myTagger = Tagger()
        
        myTagger.decomposeString(input: initString) { engStrings, tagStrings in
            
            if engStrings.count == 0 {
                return
            }
            if tagStrings.count == 0 {
                return
            }
            print(self.initString)
            print(engStrings)
            for string in engStrings {
                self.englishKeys.append(string)
                self.chineseKeys.append("placeholder")
            }
            for string in tagStrings {
                self.tagValues.append(string)
            }
        }
        print(chineseKeys)
        if self.englishKeys.count > 0 {
            var idx = 0
            for string in englishKeys {
                print(string)
                translateString(toTranslate: string, targetLang: "zh") {
                    (string, error) in
                        if let error = error {
                            print(String(describing: error))
                            self.chineseKeys[idx] = "translation error"
                            return
                        }
                        print(string)
                        let translated = string
                        DispatchQueue.main.async {
                            print(idx)
                            self.chineseKeys[idx] = translated
                            self.tableView.reloadData()
                            idx += 1
                        }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (englishKeys.count == 0) {
            return 1
        }
        return englishKeys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        
        if (chineseKeys.count == 0) {
            cell.chineseText.text = "No info"
            cell.pinyinLabel.text = "(No info)"
            cell.englishText.text = "has been found"
            cell.tagText.text = "Try another string."
            return cell
        }

        // Configure the cell...
        cell.chineseText.text = chineseKeys[indexPath.row]
        cell.pinyinLabel.text = chineseKeys[indexPath.row].toPinyin()
        cell.englishText.text = englishKeys[indexPath.row]
        cell.tagText.text = tagValues[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (englishKeys.count == 0) {
            return
        }
        let myTag = tagValues[indexPath.row]
        if myTag == "PlaceName" {
            print("gotcha")
            performSegue(withIdentifier: "mapSegue", sender: englishKeys[indexPath.row])
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
        
        if segue.identifier == "mapSegue" {
            let target = segue.destination as! MapVC
            let cell = sender as! String
            target.setupPlacemark(address: cell)
        }
    }

}
