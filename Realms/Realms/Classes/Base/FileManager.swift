//
//  RealmNavigationViewController.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import Foundation
import UIKit

class FileManager: NSObject {
    static let instance = FileManager()

    func getPathDirectory(typeDirectory: NSSearchPathDirectory) -> [String] {
        return NSSearchPathForDirectoriesInDomains(typeDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    }

    func getPathFile(name: String, typeDirectory: NSSearchPathDirectory) -> String? {
        let pathFile = getPathDirectory(typeDirectory)
        var path = pathFile.first as NSString?
        path = path?.stringByAppendingPathComponent(name)
        return path as? String
    }

    func checkFileExist(name: String, typeDirectory: NSSearchPathDirectory) -> Bool {
        let path = getPathFile(name, typeDirectory: typeDirectory)
        if NSFileManager.defaultManager().fileExistsAtPath(path!) {
            return true
        } else {
            return false
        }
    }

    func deleteFile(name: String, typeDirectory: NSSearchPathDirectory) -> Bool {
        guard let path = getPathFile(name, typeDirectory: typeDirectory) else {
            return false
        }
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch _ {
            return false
        }
        return true
    }

    func saveFile(file: UIImage, name: String, typeDirectory: NSSearchPathDirectory) -> Bool {
        guard let path = getPathFile(name, typeDirectory: typeDirectory) else { return false }
        let data = UIImageJPEGRepresentation(file, 1)
        if checkFileExist(name, typeDirectory: typeDirectory) {
            if deleteFile(name, typeDirectory: typeDirectory) {
                NSFileManager.defaultManager().createFileAtPath(path, contents: data, attributes: nil)
                return checkFileExist(name, typeDirectory: typeDirectory)
            } else {
                return false
            }
        } else {
            NSFileManager.defaultManager().createFileAtPath(path, contents: data, attributes: nil)
            return checkFileExist(name, typeDirectory: typeDirectory)
        }
    }

    func loadFile(name: String, typeDirectory: NSSearchPathDirectory) -> UIImage? {
        if checkFileExist(name, typeDirectory: typeDirectory) {
            guard let path = getPathFile(name, typeDirectory: typeDirectory) else { return nil }
            let data = NSData(contentsOfFile: path)
            return UIImage(data: data!)
        } else {
            return nil
        }
    }
}
