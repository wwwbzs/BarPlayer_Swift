//
//  main.swift
//  BBDownload
//
//  Created by Barray on 2017/4/28.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation

print("Hello, World!")

BBCommonBridge.getFile(sizeNumber: "30000000000000000000000M")

print(BBCommonBridge.calculateFileSize(contentLength: 3000000000000000.0))
