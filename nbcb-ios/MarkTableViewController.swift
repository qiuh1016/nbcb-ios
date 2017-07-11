//
//  MarkTableViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 09/07/2017.
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
    
    var unDos = [MyEvent]()
    var dones = [MyEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        showUserAlert()
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xEFEFF4, alpha: 1)
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUserAlert() {
        if UserDefault.object(forKey: "user") == nil {
            let alertController = UIAlertController(title: "请输入您的昵称", message: nil, preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                
            }
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let userTF = alertController.textFields!.first!
                if (userTF.text != "") {
                    UserDefault.set(userTF.text!, forKey: "user")
                } else {
                    self.showUserAlert()
                }
            })
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
        let alertController = UIAlertController(title: "请输入待办事项", message: nil, preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let eventTitle = alertController.textFields!.first!
            if (eventTitle.text != "") {
                self.addMyEvent(title: eventTitle.text!)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteAllDones(_ sender: Any) {
        let okHandler = {
            (action:UIAlertAction!) -> Void in
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entity = NSEntityDescription.entity(forEntityName: "MyEvent", in: self.getContext())
            fetchRequest.entity = entity
            let predicate = NSPredicate.init(format: "finished = true")
            fetchRequest.predicate = predicate
            
            do{
                let fetchedObjects = try self.getContext().fetch(fetchRequest) as! [MyEvent]
                print("fetch count: \(fetchedObjects.count)")
                //遍历查询的结果
                for info: MyEvent in fetchedObjects{
                    //删除对象
                    self.getContext().delete(info)
                    //重新保存
                    try self.getContext().save()
                }
                
                //删除数据并更新tableview
                
                var deleteIndexPaths = [IndexPath]()
                for index in  0 ... self.dones.count - 1 {
                    let deleteIndexPath = IndexPath(row: index, section: 1)
                    deleteIndexPaths.append(deleteIndexPath)
                }
                self.dones.removeAll()
                self.tableView.deleteRows(at: deleteIndexPaths, with: .fade)
                uploadLog(type: 25, event: "")
            } catch {
                let nserror = error as NSError
                fatalError("查询错误： \(nserror), \(nserror.userInfo)")
            }

        }
        
        alertView(title: "是否删除全部已完成事项", message: "", okActionTitle: "删除", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    
    func addMyEvent(title: String) {
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MyEvent", into: getContext()) as! MyEvent
        entity.title = title
        entity.finished = false
        entity.addTimestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        unDos.append(entity)
        let insertIndexPath = IndexPath(row: unDos.count - 1, section: 0)
        tableView.insertRows(at: [insertIndexPath], with: .fade)
        do {
            try getContext().save()
            uploadLog(type: 21, event: title)
        } catch {
            print("添加失败！！")
            toast(title: "添加失败", vc: self)
            unDos.remove(at: unDos.count - 1)
            tableView.deleteRows(at: [insertIndexPath], with: .fade)
        }
    }
    
    
    func getData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEvent")
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for e in (searchResults as! [MyEvent]){
                if e.finished {
                    dones.append(e)
                } else {
                    unDos.append(e)
                }
            }
            uploadLog(type: 23, event: "")
        } catch  {
            print(error)
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
            cell.detailTextLabel?.text = timeStampToString(timeStamp: unDos[indexPath.row].addTimestamp)
            cell.accessoryType = .none
            cell.textLabel?.textColor = tableViewCellTextColor
        case 1:
            cell.textLabel?.text = dones[indexPath.row].title
            cell.detailTextLabel?.text = timeStampToString(timeStamp: dones[indexPath.row].addTimestamp)
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let eventToChange = indexPath.section == 0 ? unDos[indexPath.row] : dones[indexPath.row]
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "MyEvent", in: getContext())
        fetchRequest.entity = entity
        let predicate = NSPredicate.init(format: "addTimestamp = \(eventToChange.addTimestamp)", "")
        fetchRequest.predicate = predicate
        
        do{
            let fetchedObjects = try getContext().fetch(fetchRequest) as! [MyEvent]
            print(fetchedObjects.count)
            
            //遍历查询的结果
            for info: MyEvent in fetchedObjects{
                //修改对象
                info.finished = indexPath.section == 0 ? true : false
                //重新保存
                try getContext().save()
            }
            
            //更新tableview
            if (indexPath.section == 0) {
                let event = unDos[indexPath.row]
                event.finished = true
                unDos.remove(at: indexPath.row)
                dones.insert(event, at: 0)
                let insetIndexParh = IndexPath(row: 0, section: 1)
                
                tableView.moveRow(at: indexPath, to: insetIndexParh)
                
                let cell = tableView.cellForRow(at: insetIndexParh)!
                cell.textLabel?.textColor = UIColor.gray
                cell.accessoryType = .checkmark
            } else {
                let event = dones[indexPath.row]
                event.finished = false
                dones.remove(at: indexPath.row)
                unDos.append(event)
                let insetIndexParh = IndexPath(row: unDos.count - 1, section: 0)
                tableView.moveRow(at: indexPath, to: insetIndexParh)
                let cell = tableView.cellForRow(at: insetIndexParh)!
                cell.textLabel?.textColor = tableViewCellTextColor
                cell.accessoryType = .none
            }
            
            uploadLog(type: 24, event: eventToChange.title!)
        } catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
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
            let eventToDelete = indexPath.section == 0 ? unDos[indexPath.row] : dones[indexPath.row]
            let title = eventToDelete.title
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entity = NSEntityDescription.entity(forEntityName: "MyEvent", in: getContext())
            fetchRequest.entity = entity
            let predicate = NSPredicate.init(format: "addTimestamp = \(eventToDelete.addTimestamp)", "")
            fetchRequest.predicate = predicate
            
            do{
                let fetchedObjects = try getContext().fetch(fetchRequest) as! [MyEvent]
                
                //遍历查询的结果
                for info: MyEvent in fetchedObjects{
                    //删除对象
                    getContext().delete(info)
                    //重新保存
                    try getContext().save()
                }
                
                
                //删除数据并更新tableview
                if (indexPath.section == 0) {
                    unDos.remove(at: indexPath.row)
                } else {
                    dones.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                uploadLog(type: 22, event: title!)
            } catch {
                let nserror = error as NSError
                fatalError("查询错误： \(nserror), \(nserror.userInfo)")
            }
            
            
            
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
