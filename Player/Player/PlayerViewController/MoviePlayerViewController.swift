//
//  MoviePlayerViewController.swift
//  Player
//
//  Created by Barray on 2017/4/26.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

class MoviePlayerViewController: UIViewController {
    var videoURL:URL?
    
    @IBOutlet private weak var videoSuperView: UIView!
    
    lazy var playerView:BARPlayerView = {
        let playerView = BARPlayerView()
        playerView.player(controlView: nil, model: self.playerModel)
        playerView.delegate = self
        playerView.isCanDownLoad = true
        playerView.isHasPreview = true
        return playerView
    }()
    
    var isPlayingDis:Bool = false
    lazy var playerModel:BARPlayerModel = {
        let playerModel = BARPlayerModel()
        playerModel.title = "标题"
        playerModel.videoURL = self.videoURL
        playerModel.placeholderImage = UIImage(named: "loading_bgView1")
        
        playerModel.superView = self.videoSuperView
        return playerModel
    }()
    
    var bottomView:UIView?
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bar_prefersNavigationBarHidden = true
        self.playerView.playerAutoTheVideo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isPlayingDis {
            self.isPlayingDis = false
            self.playerView.playerPushOrPress = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.playerView.isPauseByUser {
            self.isPlayingDis = true
            self.playerView.playerPushOrPress = true
        }
    }
    


    @IBAction func backAction(_ sender: Any) {
    }
    
    
    
    @IBAction func playNewVideo(_ sender: UIButton) {
    }
    
    deinit {
        self.navigationController?.bar_popToMovieViewControllerBlock = nil
        print("释放了\(self.classForCoder)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//TODO: ----getter setter
extension MoviePlayerViewController{
    override var shouldAutorotate: Bool{
        get{
            return false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return UIStatusBarStyle.lightContent
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        get{
            return BARBrightnessView.instance.getIsStatusBarHidden()
        }
    }
}


//MARK: - PlayerDelegate
extension MoviePlayerViewController: BARPlayerViewDelegate {
    
}





