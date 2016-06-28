//
//  HomeViewController.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: RealmViewController  {
  
    var datasouce: Results<Student>!
    var myHomeCell: HomeCell?
    var student = Student ()
    var realm = try! Realm()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HOME"
        self.getNavigation()
        self.buttonBar()
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.reloadTable()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    
    func reloadTable(){
     
        do {
            let realm = try Realm()
            datasouce = realm.objects(Student)
            self.tableView?.reloadData()
        }
        catch {
            
        }
    }
  }

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasouce.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell:HomeCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! HomeCell
        let student = datasouce[indexPath.row]
        cell.nameLabel.text = student.name
        print(student.name)
        cell.ageLabel.text = String(student.age)
        cell.genderLable.text = student.gender
        if !student.imageName.isEmpty {
           cell.thumbImageView.image = FileManager.instance.loadFile(student.imageName, typeDirectory: NSSearchPathDirectory.DocumentDirectory)
        }
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.width / 2
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("Cell \(indexPath.row) of Section \(indexPath.section) ")
        let myProfile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let item = datasouce[indexPath.row]
        myProfile.student = item
        myProfile.delegate = self
        self.navigationController?.pushViewController(myProfile, animated: true)
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteRowAtIndexPath(indexPath)
        }
    }
    
    private func deleteRowAtIndexPath(indexPath: NSIndexPath) {
        
        let objectToDelete = datasouce[indexPath.row]
        FileManager.instance.deleteFile(objectToDelete.imageName, typeDirectory: NSSearchPathDirectory.DocumentDirectory)
        do {
            try realm.write() {
                realm.delete(objectToDelete)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } catch {
            print("Could not delete site")
        }
    }

    
}
extension HomeViewController: ProfileViewControllerDelege {
    func showData(name: String, age: Int, gender: String, imageAvatar: UIImage) {
        self.myHomeCell?.nameLabel.text = name
        self.myHomeCell?.ageLabel.text = String(age)
        self.myHomeCell?.genderLable.text = gender
        self.myHomeCell?.imageView?.image = imageAvatar
        self.reloadTable()
    }
}