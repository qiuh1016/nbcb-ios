//
//  ViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 05/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var shouyiTF: UITextField!
    @IBOutlet weak var dayTF: UITextField!
    @IBOutlet weak var moneyTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getProfit(_ sender: Any) {
        resignTF();
        
        if (shouyiTF.text == "" || dayTF.text == "" || dayTF.text == "") {
            showErrAlert()
            return
        }
        
        let profitPer = Double(shouyiTF.text!)
        let day = Double(dayTF.text!)
        let money = Double(moneyTF.text!)
        
        let profit = money! * 10000 * profitPer! / 100 * day! / 365;
        
        let message = String(format: "%.2f", profit) + "元"
        let alertController = UIAlertController(title: "收益", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showErrAlert() {
        let alertController = UIAlertController(title: "提示", message: "输入不全", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resignTF() {
        shouyiTF.resignFirstResponder();
        dayTF.resignFirstResponder();
        moneyTF.resignFirstResponder();
    }

}

