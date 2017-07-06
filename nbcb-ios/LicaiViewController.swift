//
//  ViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 05/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import UIKit

class LicaiViewController: UIViewController {

    @IBOutlet weak var shouyiTF: UITextField!
    @IBOutlet weak var dayTF: UITextField!
    @IBOutlet weak var moneyTF: UITextField!
    
    @IBOutlet weak var getProfitButton: UIButton!
    
    @IBOutlet weak var spaceConstraint_1: NSLayoutConstraint!
    @IBOutlet weak var spaceConstraint_2: NSLayoutConstraint!
    
    @IBOutlet weak var toLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var toRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getProfitButton.layer.cornerRadius = getProfitButton.bounds.height / 4
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShouyilvViewController.resignTF))
        self.view.addGestureRecognizer(tapGesture)
        
        
        if (iPhone5()) {
            spaceConstraint_1.constant = 29
            spaceConstraint_2.constant = 29
            
            toLeftConstraint.constant = 20
            toRightConstraint.constant = 62
            
            toTopConstraint.constant = 0
            
            view.layer.layoutIfNeeded();
        }
        
        
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
//        let alertController = UIAlertController(title: "收益", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
        
        alertView(title: "收益", message: message, okActionTitle: "好的", okHandler: nil, viewController: self)
        
    }
    
    func showErrAlert() {
//        let alertController = UIAlertController(title: "提示", message: "输入不全", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
        
        alertView(title: "提示", message: "输入不全", okActionTitle: "好的", okHandler: nil, viewController: self)
    }
    
    func resignTF() {
        shouyiTF.resignFirstResponder();
        dayTF.resignFirstResponder();
        moneyTF.resignFirstResponder();
    }

}

