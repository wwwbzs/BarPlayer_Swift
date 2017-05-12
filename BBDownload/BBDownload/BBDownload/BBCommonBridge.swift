//
//  BBCommonBridge.swift
//  BBDownload
//
//  Created by Barray on 2017/4/28.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Cocoa

let BASE = "BBDownLoad"
let TARGET = "CacheList"
let TEMP = "Temp"
let PLIST_DOWN = "FinishedDownLoadPlist.plist"

let CACHES_DIRECTORY = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
let TEMP_FOLDER = ((CACHES_DIRECTORY! as NSString).appendingPathComponent(BASE) as NSString).appendingPathComponent(TEMP)

func TEMP_PATH(fileName:String) throws -> String {
    return try (BBCommonBridge.createFolder(path: TEMP_FOLDER) as NSString).appendingPathComponent(fileName)
}

let FILE_FOLDER_DOWNLOAD = ((CACHES_DIRECTORY! as NSString).appendingPathComponent(BASE) as NSString).appendingPathComponent(TARGET)


func FILE_FOLDER_DOWNLOAD(fileName:String) throws -> String {
    return try (BBCommonBridge.createFolder(path: FILE_FOLDER_DOWNLOAD) as NSString).appendingPathComponent(fileName)
}

let PLIST_PATH = ((CACHES_DIRECTORY! as NSString).appendingPathComponent(BASE) as NSString).appendingPathComponent(PLIST_DOWN)

extension String{
    func asNSString() -> NSString {
        return self as NSString
    }
}

class BBCommonBridge: NSObject  {
    
    /** 将文件大小转化成M单位或者B单位 */
    static func getFile(sizeString:String) -> String {
        let sizeFloat = (sizeString as NSString).floatValue
        if sizeFloat >= 1024*1024*1024{
            return String(format: "%.2fG", arguments: [sizeFloat/pow(1024, 3)])
        } else if sizeFloat >= 1024*1024 {
            return String(format: "%.2fM", arguments: [sizeFloat/pow(1024, 2)])
        } else if sizeFloat >= 1024{
            return String(format: "%.2fK", arguments: [sizeFloat/1024])
        } else{
            return String(format: "%.2fB", arguments: [sizeFloat])
        }
    }
    
    /** 将文件大小转化成不带单位的数字 */
    static func getFile(sizeNumber:String) -> Float {
        let sizeString = sizeNumber as NSString
        let indexG = sizeString.range(of: "G").location
        let indexM = sizeString.range(of: "M").location
        let indexK = sizeString.range(of: "K").location
        let indexB = sizeString.range(of: "B").location
        if indexG != NSNotFound {
            return sizeString.substring(to: indexM).asNSString().floatValue*1024*1024*1024
        } else if indexM != NSNotFound {
            return sizeString.substring(to: indexM).asNSString().floatValue*1024*1024
        } else if indexK != NSNotFound {
            return sizeString.substring(to: indexK).asNSString().floatValue*1024*1024
        } else{
            return sizeString.substring(to: indexB).asNSString().floatValue
        }
    }
    
    static func makeDate(birthday:String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: birthday)
    }
    
    static func string(from:Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: from)
    }
    
    /** 检查文件名是否存在 */
    static func isExistFile(file:String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: file)
    }
    
    static func createFolder(path:String)  throws -> String{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
           try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    static func calculateFileSize(contentLength:CGFloat) -> CGFloat {
        if contentLength >= pow(1024, 3) {
            return contentLength / pow(1024, 3)
        } else if contentLength >= pow(1024, 2){
            return contentLength / pow(1024, 2)
        } else if contentLength > 1024 {
            return contentLength/1024
        } else {
            return contentLength
        }
    }
    
    func calculate(contentLength:CGFloat) -> String {
        if contentLength >= pow(1024, 3) {
            return "GB"
        } else if contentLength >= pow(1024, 2){
            return "MB"
        } else if contentLength > 1024 {
            return "KB"
        } else {
            return "B"
        }
    }
}
