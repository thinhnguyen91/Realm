//
//  DetailViewController.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmSwift

enum Gender: Int {
    case Nam = 0
    case Nu
    var title: String? {
        switch self {
        case Nam: return "Nam"
        case Nu: return "Nữ"
        }
    }
}

class DetailViewController: RealmViewController {
    
    var imagePick = UIImagePickerController()
    var datePickerView: DatePickerView?
    var agePickerView: PickerView?
    var student = Student()
    var ageData = [String]()
    var ageIndexSelected = 0
    var buttonDone = UIButton()
    var students = [Student]()
    var image: UIImage?
    var nameValid = false {
        didSet {
            nameInvalidMessageLabel.hidden = nameValid
        }
    }
    var ageValid = false {
        didSet {
            let alert = UIAlertController(title: "Error", message: "Hãy Nhập Tuổi", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            if !ageValid {
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameInvalidMessageLabel: UILabel!
    @IBOutlet weak var segmenControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ADD"
        self.getNavigation()
        self.buttonBarDone()
        self.textFieldShouldReturn(nameTextField)
        self.textFieldShouldReturn(ageTextField)
        self.avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        self.avatarImage.clipsToBounds = true
        self.buttonImage.layer.cornerRadius = buttonImage.frame.size.width / 2
        self.buttonImage.clipsToBounds = true
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        self.imagePick.delegate = self
        for i in 10..<120 {
            ageData.append("\(i)")
        }
    }
    
    //MARK: Private
    private func checkUserValid() -> Bool {
        guard let _ = nameTextField.text where nameTextField.text != nil && nameTextField.text != "" else {
            return false
        }
        
        return true
    }
    
    private func checkAgeValid() -> Bool {
        guard let _ = ageTextField.text where ageTextField.text != "" && ageTextField != nil else {
            return false
        }
        return true
    }
    
    //MARK: Action
    @IBAction func segmentedGender(sender: AnyObject) {
        
    }
    
    @IBAction func clickAvatar(sender: AnyObject) {
        
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
    
    @IBAction func birthDatePickerAction(sender: UIButton) {
        agePickerView = NSBundle.mainBundle().loadNibNamed("PickerView", owner: self, options: nil)[0] as? PickerView
        agePickerView?.delegate = self
        agePickerView?.initPicker(ageData, pickerIndex: ageIndexSelected)
        self.view.addSubview(agePickerView!)
    }
    
    func buttonBarDone() {
        buttonDone.setImage(UIImage(named: "Ok-25"), forState: .Normal)
        buttonDone.frame = CGRectMake(0, 0, 25, 25)
        buttonDone.addTarget(self, action: #selector(DetailViewController.doneAction(_:)), forControlEvents: .TouchUpInside)
        let starButtonItem = UIBarButtonItem()
        starButtonItem.customView = buttonDone
        self.navigationItem.rightBarButtonItem = starButtonItem
    }
    
    func doneAction(sender: UIBarButtonItem) {
        nameValid = self.checkUserValid()
        ageValid = self.checkAgeValid()
        if nameValid && ageValid {
            self.doneContacts()
        }
    }
    
    func doneContacts(){
        
        if let nameTF = self.nameTextField.text {
            student.name = nameTF
        }
        if let ageTF = self.ageTextField.text {
            student.age = Int(ageTF)!
        }
        let indexGender = Gender(rawValue: segmenControl.selectedSegmentIndex)
        student.gender = (indexGender?.title)!
        if let image = image {
            student.imageName = saveImage(image)
        }
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.add(student)
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.avatarImage.image = image
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
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePick.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePick, animated: true, completion: nil)
        }
        else {
            print("No camera")
        }
    }
    
    func saveImage(image: UIImage) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh.mm.ss"
        let filename = "\(dateFormatter.stringFromDate(NSDate())).png"
        FileManager.instance.saveFile(image, name: filename, typeDirectory:NSSearchPathDirectory.DocumentDirectory)
        return filename
    }
}

extension DetailViewController: PickerViewCustomDelegate {
    func pickerViewSelectAtIndext(index: Int) {
        ageTextField.text = ageData[index]
        ageIndexSelected = index
    }
}