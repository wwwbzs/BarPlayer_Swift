//
//  BBRequest.swift
//  BBDownload
//
//  Created by Barray on 2017/4/28.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation
import Alamofire


protocol BBRequestDelegate:NSObjectProtocol {
    func request(failed:BBRequest)
    func request(start:BBRequest)
    func request(_ request:BBRequest,didReceive responseHeaders:Dictionary<String, Any>)
    func request(_ request:BBRequest,didReceive bytes:UInt64)
    func request(finished request:BBRequest)
    func request(_ request:BBRequest,willRedirect newUrl:NSURL)
}

class BBRequest: NSObject {
    weak var delegate:BBRequestDelegate?
    var url:URL
    var originalURL:NSURL?
    var userInfo:Dictionary<String, Any>?
    var tag:NSInteger?
    var downloadDestinationPath:String?{
        didSet{
           let s = downLoadRequest.description
        }
    }
    var temporaryFileDownloadPath:String?
    var error:NSError?
    
    private var downLoadRequest:DownloadRequest
    
    init(url:URL) {
        self.url = url
        downLoadRequest = download(url)
        
    }
    
    
    
//    func downloadAnduploadMethod() {
//        //下载文件
//        Alamofire.download(host_img_url).responseJSON { (returnResult) in
//            if let data = returnResult.result.value {
//                let image = UIImage(data : data as! Data)
//                print("\(image)")
//            }else {
//                print("download is fail")
//            }
//        }
//        
//        //还可以看下载进度
//        Alamofire.download(host_img_url).downloadProgress { (progress) in
//            print("download progress = \(progress.fractionCompleted)")
//            }.responseJSON { (returnResult) in
//                if let data = returnResult.result.value {
//                    let image = UIImage(data : data as! Data)
//                    print("\(image)")
//                }else {
//                    print("download is fail")
//                }
//        }
//        
//    }
    
}
