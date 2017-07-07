//
//  MarkTableViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 07/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import Just

class MarkTableViewController: UITableViewController {
    
//    var unDos = ["电销30个电话", "新客户理财", "存款300万"]
//    var dones = ["银监论文上交", "vlookup函数学习"]

    var unDos = [Myevent]()
    var dones = [Myevent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xEFEFF4, alpha: 1)
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
        addMyevent(title: "已完成", finished: 1)
        
    }
    
    func addMyevent(title: String, finished: Int) {
        Alamofire.request(url + "add", parameters: ["title": title, "finished": finished]).responseJSON { response in
            let json = JSON(data: response.data!)
            if (json["success"].boolValue) {
                let result = json["result"]
                let myevent = Myevent(title: title, id: result["insertId"].intValue, finished: finished)
                if (finished == 0) {
                    self.unDos.append(myevent)
                    let indexpath = IndexPath(row: self.unDos.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexpath], with: .fade)
                } else {
                    self.dones.insert(myevent, at: 0)
                    let indexpath = IndexPath(row: 0, section: 1)
                    self.tableView.insertRows(at: [indexpath], with: .fade)
                }
                
            }
        }
    }
    
    func getData() {
        
        Alamofire.request(url + "get").responseJSON { response in

            let json = JSON(data: response.data!)
            if (json["success"].boolValue) {
                let result = json["result"]
                for i in 0 ..< result.count {
                    let myevent = Myevent(title: result[i]["title"].stringValue, id: result[i]["id"].intValue, finished: result[i]["finished"].intValue)
                    if myevent.finished == 0 {
                        self.unDos.append(myevent)
                    } else {
                        self.dones.insert(myevent, at: 0)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return unDos.count
        case 1:
            return dones.count
        default:
            return 0
        }

        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = unDos[indexPath.row].title
            cell.accessoryType = .none
        case 1:
            cell.textLabel?.text = dones[indexPath.row].title
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if (indexPath.section == 0) {
            let event = unDos[indexPath.row]
            unDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            dones.insert(event, at: 0)
            let insetIndexParh = IndexPath(row: 0, section: 1)
            tableView.insertRows(at: [insetIndexParh], with: .fade)
            
            let cell = tableView.cellForRow(at: insetIndexParh)!
            cell.textLabel?.textColor = UIColor.gray
        } else {
            let event = dones[indexPath.row]
            dones.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            unDos.append(event)
            let insetIndexParh = IndexPath(row: unDos.count - 1, section: 0)
            tableView.insertRows(at: [insetIndexParh], with: .fade)
            
            let cell = tableView.cellForRow(at: insetIndexParh)!
            cell.textLabel?.textColor = tabelViewCellTextColor
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "未完成事项"
        case 1:
            return "已完成事项"
        default:
            return "error"
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if (indexPath.section == 0) {
                unDos.remove(at: indexPath.row)
            } else {
                dones.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
