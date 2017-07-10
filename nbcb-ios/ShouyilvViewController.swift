//
//  ShouyilvViewController.swift
//  nbcb-ios
//
//  Created by qiuhong on 05/07/2017.
//  Copyright © 2017 qh. All rights reserved.
//

import UIKit

class ShouyilvViewController: UIViewController {
    
    
    @IBOutlet weak var licaiProfitPerTF: UITextField!
    @IBOutlet weak var cunkuanProfitPerTF: UITextField!
    @IBOutlet weak var zhitoubiTF: UITextField!
    
    @IBOutlet weak var dayTF: UITextField!
    @IBOutlet weak var moneyTF: UITextField!
    
    @IBOutlet weak var shouyilvButton: UIButton!
    @IBOutlet weak var shouyiButton: UIButton!
    
    @IBOutlet weak var spaceConstraint_1: NSLayoutConstraint!
    @IBOutlet weak var spaceConstraint_2: NSLayoutConstraint!
    @IBOutlet weak var spaceConstraint_3: NSLayoutConstraint!
    
    @IBOutlet weak var toLeftConstraint_1: NSLayoutConstraint!
    @IBOutlet weak var toLeftConstraint_2: NSLayoutConstraint!
    
    @IBOutlet weak var toRightConstraint_1: NSLayoutConstraint!
    @IBOutlet weak var toRightConstraint_2: NSLayoutConstraint!
    
    @IBOutlet weak var toTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        shouyilvButton.layer.cornerRadius = shouyilvButton.bounds.height / 4
        shouyiButton.layer.cornerRadius = shouyiButton.bounds.height / 4
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShouyilvViewController.resignTF))
        self.view.addGestureRecognizer(tapGesture)
        
        
        if (iPhone5()) {
            print(5)
            spaceConstraint_1.constant = 29
            spaceConstraint_2.constant = 29
            spaceConstraint_3.constant = 29
            
            toLeftConstraint_1.constant = 20
            toLeftConstraint_2.constant = 20
            
            toRightConstraint_1.constant = 62
            toRightConstraint_2.constant = 62
            
            toTopConstraint.constant = 0;
            
            view.layer.layoutIfNeeded();
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getProfitPre(_ sender: Any) {
        resignTF();
        
        if (licaiProfitPerTF.text == "" || cunkuanProfitPerTF.text == "" || zhitoubiTF.text == "") {
            showErrAlert()
            return
        }
        
        let licaiProfitPer = Double(licaiProfitPerTF.text!)
        let cunkuanProfitPer = Double(cunkuanProfitPerTF.text!)
        let zhitoubi = Double(zhitoubiTF.text!)
        
        var profitPer = zhitoubi! / (zhitoubi! + 1) * licaiProfitPer!
        profitPer += 1 / (zhitoubi! + 1) * cunkuanProfitPer!
        
        let message = String(format: "%.2f", profitPer) + "%"

        alertView(title: "收益率", message: message, okActionTitle: "好的", okHandler: nil, viewController: self)
        uploadLog(type: 12, event: "")

    }

    @IBAction func getProfit(_ sender: Any) {
        resignTF();
        
        if (licaiProfitPerTF.text == "" || cunkuanProfitPerTF.text == "" || zhitoubiTF.text == "") {
            showErrAlert()
            return
        }
        
        let licaiProfitPer = Double(licaiProfitPerTF.text!)
        let cunkuanProfitPer = Double(cunkuanProfitPerTF.text!)
        let zhitoubi = Double(zhitoubiTF.text!)
        let day = Double(dayTF.text!)
        let money = Double(moneyTF.text!)
        
        var profitPer = zhitoubi! / (zhitoubi! + 1) * licaiProfitPer!
        profitPer += 1 / (zhitoubi! + 1) * cunkuanProfitPer!
        
        let profit = money! * 10000 * profitPer / 100 * day! / 365;
        
        let message = String(format: "%.2f", profit) + "元"
        
        alertView(title: "收益", message: message, okActionTitle: "好的", okHandler: nil, viewController: self)
        uploadLog(type: 13, event: "")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showErrAlert() {
        alertView(title: "提示", message: "输入不全", okActionTitle: "好的", okHandler: nil, viewController: self)
    }
    
    func resignTF() {
        licaiProfitPerTF.resignFirstResponder();
        cunkuanProfitPerTF.resignFirstResponder();
        zhitoubiTF.resignFirstResponder();
        dayTF.resignFirstResponder();
        moneyTF.resignFirstResponder();
    }

}
