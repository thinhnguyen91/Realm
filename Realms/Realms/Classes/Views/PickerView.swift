//
//  PickerView.swift
//  st_ios
//
//  Created by dang ngoc khanh quang on 1/28/16.
//  Copyright © 2016 shueisha. All rights reserved.
//

import UIKit

protocol PickerViewCustomDelegate: class {
    func pickerViewSelectAtIndext(index: Int)
}
class PickerView: UIView {
    @IBOutlet private weak var maskOfView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    var pickerViewData: [String]!
    weak var delegate: PickerViewCustomDelegate?
    private var isShow: Bool? {
        didSet {
            if isShow == true {
                show()
            } else {
                hide()
            }
        }
    }
    // MARK : - Public
    func initPicker(pickerData: [String]!, pickerIndex: Int) {
        self.frame = UIScreen.mainScreen().bounds
        var rectContent = contentView.frame
        rectContent.origin.y += rectContent.size.height
        contentView.frame = rectContent
        pickerViewData = pickerData
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(pickerIndex, inComponent: 0, animated: false)
        isShow = true
        let touchMask = UITapGestureRecognizer(target: self, action: #selector(PickerView.maskTapGesture(_:)))
        maskOfView.addGestureRecognizer(touchMask)
    }
    // MARK: - Private
    private func show() {
        var rectContent = contentView.frame
        rectContent.origin.y -= rectContent.size.height
        UIView.animateWithDuration(0.3) {() -> Void in
            self.contentView.frame = rectContent
        }
    }
    
    private func hide() {
        var rectContent = contentView.frame
        rectContent.origin.y += rectContent.size.height
        UIView.animateWithDuration(0.3, animations: {() -> Void in
                self.contentView.frame = rectContent
            }) {(Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func maskTapGesture(sender: UITapGestureRecognizer) {
        isShow = false
    }
    
    // MARK : - Action
    @IBAction func cancelAction(sender: UIButton) {
        isShow = false
    }
    
    @IBAction func doneAction(sender: UIButton) {
        self.delegate?.pickerViewSelectAtIndext(pickerView.selectedRowInComponent(0))
        isShow = false
    }
}

//MARK: - UIPickerViewDelegate
extension PickerView: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?)
        -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = pickerViewData[row]
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
}

//MARK : - UIPickerViewDataSource
extension PickerView: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
}
