//
//  ProfileViewController.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmSwift

protocol ProfileViewControllerDelege {
    func showData(name: String, age: Int, gender: String, imageAvatar: UIImage)
}

class ProfileViewController: RealmViewController {

    var imagePick = UIImagePickerController()
    var student: Student!
    var buttonSave = UIButton()
    var delegate: ProfileViewControllerDelege?
    var myDetailVC: DetailViewController?
    var image: UIImage?
    var ageData = [String]()
    var agePickerView: PickerView?
    var ageIndexSelected = 0

    @IBOutlet weak var butionAge: UIButton!
    @IBOutlet weak var ageProfileTF: UITextField!
    @IBOutlet weak var nameProfileTF: UITextField!
    @IBOutlet weak var avatarProfile: UIImageView!
    @IBOutlet weak var genderProfile: UITextField!
    @IBOutlet weak var buttonAvatarProfile: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "PROFILE "
        self.getNavigation()
        self.buttonBarSave()
        self.textFieldShouldReturn(nameProfileTF)
        self.textFieldShouldReturn(ageProfileTF)
        self.textFieldShouldReturn(genderProfile)
        self.avatarProfile.layer.cornerRadius = avatarProfile.frame.size.width / 2
        self.avatarProfile.clipsToBounds = true
        self.nameProfileTF.text = student.name
        self.ageProfileTF.text = String(student.age)
        self.genderProfile.text = student.gender
        self.nameProfileTF.delegate = self
        self.ageProfileTF.delegate = self
        self.genderProfile.delegate = self
        self.imagePick.delegate = self
        self.buttonAvatarProfile.layer.cornerRadius = buttonAvatarProfile.frame.size.width / 2
        self.buttonAvatarProfile.clipsToBounds = true
        if !student.imageName.isEmpty {
            self.avatarProfile.image = FileManager.instance.loadFile(student.imageName, typeDirectory: NSSearchPathDirectory.DocumentDirectory)
        }
        for i in 10..<120 {
            ageData.append("\(i)")
        }

    }

    // MARK: Action
    func buttonBarSave() {
        buttonSave.setImage(UIImage(named: "Save Filled-25"), forState: .Normal)
        buttonSave.frame = CGRectMake(0, 0, 25, 25)
        buttonSave.addTarget(self, action: #selector(ProfileViewController.saveAction(_:)), forControlEvents: .TouchUpInside)
        let starButtonItem = UIBarButtonItem()
        starButtonItem.customView = buttonSave
        self.navigationItem.rightBarButtonItem = starButtonItem
    }

    @IBAction func buttonAction(sender: AnyObject) {
        print("kich image")
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            self.openCamera() }
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            self.openPicture() }
        actionSheetController.addAction(takePictureAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(choosePictureAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    @IBAction func buttonAge(sender: AnyObject) {
        agePickerView = NSBundle.mainBundle().loadNibNamed("PickerView", owner: self, options: nil)[0] as? PickerView
        agePickerView?.delegate = self
        agePickerView?.initPicker(ageData, pickerIndex: ageIndexSelected)
        self.view.addSubview(agePickerView!)
    }

    @IBAction func buttonDelete(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Delete contacts", message: "", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
               
                if !self.student.imageName.isEmpty {
                    FileManager.instance.deleteFile(self.student.imageName, typeDirectory: NSSearchPathDirectory.DocumentDirectory)
                }
                realm.delete(self.student)
                
            })
            } catch {
                
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }

    }

    // MARK: FUNC
    func saveAction(sender: UIBarButtonItem) {

        print("ckick save")
        if let delegate = self.delegate {
            delegate.showData(self.nameProfileTF.text!, age: Int(self.ageProfileTF.text!)!, gender: self.genderProfile.text!, imageAvatar: self.avatarProfile.image!)
            do {
                let realm = try Realm()
                try realm.write ({ () -> Void in
                    student.name = self.nameProfileTF.text!
                    student.age = Int(self.ageProfileTF.text!)!
                    student.gender = self.genderProfile.text!
                    if let image = image {
                        student.imageName = saveImage(image)
                    }

                })
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        self.navigationController?.popToRootViewControllerAnimated(true)

    }

    func saveImage(image: UIImage) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh.mm.ss"
        let filename = "\(dateFormatter.stringFromDate(NSDate())).png"
        FileManager.instance.saveFile(image, name: filename, typeDirectory: NSSearchPathDirectory.DocumentDirectory)
        return filename
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ProfileViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.avatarProfile.image = image
        self.image = image
    }

    func openPicture() {
        imagePick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePick.delegate = self
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(imagePick, animated: true, completion: nil)
        }
    }

    func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePick.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePick, animated: true, completion: nil)
        }
        else {
            print("No camera")
        }
    }
}

extension ProfileViewController: PickerViewCustomDelegate {
    func pickerViewSelectAtIndext(index: Int) {
        ageProfileTF.text = ageData[index]
        ageIndexSelected = index
    }
}
