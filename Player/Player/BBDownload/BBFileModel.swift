//
//  BBFileModel.swift
//  BBDownload
//
//  Created by Barray on 2017/4/28.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation
import UIKit

enum BBDownloadState:NSInteger {
    case loading
    case will
    case stop
    case finsh
}

class BBFileModel: NSObject {
    var fileName:String?
    var fileSize:String?
    var fileType:String?
    var isFirstReceived:Bool?
    var fileReceivedSize:String?
    var fileReceivedData:Data?
    var fileUrl:String?
    var time:String?
    var tempPath:String?
    var speed:String?
    var startTime:Date?
    var remainingTime:String?
    var state:BBDownloadState?
    var isError:Bool?
    var MD5:String?
    var fileimage:UIImage?
    
}
