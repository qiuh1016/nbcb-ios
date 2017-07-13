//
//  HistoryTableViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 12/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class History {
    var type: Int
    var event: String
    var addtime: String
    init(type: Int, event: String, addtime: String) {
        self.type = type
        self.event = event
        self.addtime = addtime
    }
}



class HistoryTableViewController: UITableViewController {
    
    var historys = [History]()
    var refreshData = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
        historys.removeAll()
        Alamofire.request(url + "getByName", parameters: ["user": "小鸡仔"]).responseJSON { response in
            let json = JSON(data: response.data!)
            print("get data ok")
            if (json["success"].boolValue) {
                let result = json["result"]
                for index in 0 ..< result.count {
                    let h = History.init(type: result[index]["type"].intValue, event: result[index]["event"].stringValue, addtime: result[index]["date_format(addtime,'%Y-%m-%d %H:%i:%s')"].stringValue)
                    self.historys.append(h)
                }
                self.tableView.reloadData()
                if self.refreshData {
                    toast(title: "已更新", vc: self)
                    self.refreshData = false
                }
                
                
            }
        }
    }
    
    
    @IBAction func refreshData(_ sender: Any) {
        refreshData = true
        getData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let history = historys[indexPath.row]
        if (history.event != "") {
            cell.textLabel?.text = "\(switchType(type: history.type)) : \(history.event)"
        } else {
            cell.textLabel?.text = switchType(type: history.type)
        }
        
        cell.detailTextLabel?.text = history.addtime

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
