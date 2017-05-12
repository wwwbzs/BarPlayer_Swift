//
//  ViewController.swift
//  PlayerDemo
//
//  Created by Barray on 2017/5/4.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var playerView:PlayerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        playerView!.model = BARPlayerModel()
        playerView!.model?.videoURL = URL(string: "http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4")
        playerView?.set(PlayerControlView())
        self.view.addSubview(playerView!)
        playerView?.snp.makeConstraints({ (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(300)
            make.top.equalTo(0)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        
        playerView!.backgroundColor = UIColor.black
        playerView!.play()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override var shouldAutorotate: Bool{
        get{
            return false
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        get{
            return false
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return UIStatusBarStyle.lightContent
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
    
    @IBAction func cacleAction(_ sender: Any) {
        playerView!.removeFromSuperview()
        playerView = nil
    }
    @IBOutlet weak var caclePlay: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

