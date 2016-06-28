//
//  RealmNavigationViewController.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import Realm

class RealmViewController: UIViewController {

    var buttonAdd =  UIButton()
   
    
    var detailvc: DetailViewController!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
        self.navigationController?.navigationBar.tintColor  = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNavigation() {
        
          }
    
    func buttonBar() {
        buttonAdd.setImage(UIImage(named: "Plus-25"), forState: .Normal)
        buttonAdd.frame = CGRectMake(0, 0, 25, 25)
        buttonAdd.addTarget(self, action: #selector(RealmViewController.addAction(_:)), forControlEvents: .TouchUpInside)
        let starButtonItem = UIBarButtonItem()
        starButtonItem.customView = buttonAdd
        self.navigationItem.rightBarButtonItem = starButtonItem
    }
    
    func addAction(sender: UIBarButtonItem) {
        print("ckick add")
        let myDetailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        self.navigationController?.pushViewController(myDetailVC, animated: true)
        
    }
    
  

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

}
