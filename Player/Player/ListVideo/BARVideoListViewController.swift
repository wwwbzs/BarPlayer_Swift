//
//  BARVideoListViewController.swift
//  Player
//
//  Created by Barray on 2017/4/26.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

class BARVideoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var dataSource:[String]!
    
    @objc fileprivate func updateLayer(_ notify:Notification){
        print(1234556666)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.bar_prefersNavigationBarHidden = true
        print(self.bar_prefersNavigationBarHidden)
//        let b = BARBrightnessView.instance.isLockScreen
//        print(b)
        
        dataSource = ["http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                       "http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                        "http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                         "http://baobab.wdjcdn.com/14525705791193.mp4",
                          "http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                           "http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                            "http://baobab.wdjcdn.com/1455782903700jy.mp4",
                             "http://baobab.wdjcdn.com/14564977406580.mp4",
                              "http://baobab.wdjcdn.com/1456316686552The.mp4",
                               "http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                                "http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                                 "http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                                  "http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                                   "http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                                    "http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                                     "http://baobab.wdjcdn.com/1456653443902B.mp4",
                                      "http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
        // Do any additional setup after loading the view.
    }
    
//    override var shouldAutorotate()-> Bool{
//        return true
//    }
    override var shouldAutorotate: Bool{
        get{
          return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "netListCell")
        cell?.textLabel?.text = String.init(format: "网络视频%zd", indexPath.row+1)
        return cell!;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movie = segue.destination as! MoviePlayerViewController
        let cell = sender as! UITableViewCell
        let indexPath = self.tableview.indexPath(for: cell)
        self.tableview.deselectRow(at: indexPath!, animated: true)
        let url = URL(string: self.dataSource[indexPath!.row])
        print(url!)
        movie.videoURL = url
    }
 

}
