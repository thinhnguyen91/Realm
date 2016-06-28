//
//  DatePickerView.swift
//  st_ios
//
//  Created by dang ngoc khanh quang on 2/15/16.
//  Copyright © 2016 shueisha. All rights reserved.
//

import UIKit
protocol DatePickerViewDelegate: class {
    func datePickerViewSelectAtDate(dateIndex: String)
}
class DatePickerView: UIView {
    @IBOutlet private weak var maskOfView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var datepicker: UIDatePicker!
    weak var delegate: DatePickerViewDelegate?
    var isShow: Bool? {
        didSet {
            if isShow == true {
                show()
            } else {
                hide()
            }
        }
    }
    
    // MARK: - Public
    func initDataPicker() {
        self.frame = UIScreen.mainScreen().bounds
        var rectContent = contentView.frame
        rectContent.origin.y -= contentView.frame.size.height
        contentView.frame = rectContent
        isShow = true
        let touchMask = UITapGestureRecognizer(target: self, action:  #selector(DatePickerView.maskTapGesture(_:)))
        maskOfView.addGestureRecognizer(touchMask)
        datepicker.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        datepicker.maximumDate = NSDate.init()
    }
    
    // MARK: - Private
    func maskTapGesture(sender: UITapGestureRecognizer) {
        isShow = false
    }
    
    private func hide() {
        var rectContent = contentView.frame
        rectContent.origin.y += self.contentView.frame.size.height
        UIView.animateWithDuration(0.3, animations: {() -> Void in
                self.contentView.frame = rectContent
            }) {(Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    private func show() {
        var rectContent = contentView.frame
        rectContent.origin.y -= self.contentView.frame.size.height
        UIView.animateWithDuration(0.3) {() -> Void in
            self.contentView.frame = rectContent
        }
    }
    
    private func getDateStringFromDatePicker(dateSelect: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(dateSelect)
    }
    
    // MARK: - Action
    @IBAction func cancelButtonAction(sender: UIButton) {
        isShow = false
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        self.delegate?.datePickerViewSelectAtDate(getDateStringFromDatePicker(datepicker.date))
        isShow = false
    }
}
