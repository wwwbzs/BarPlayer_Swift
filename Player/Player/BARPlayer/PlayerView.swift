//
//  PlayerView.swift
//  Player
//
//  Created by Barray on 2017/5/3.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    lazy var player:Player = {
        return Player.player(self.model!.videoURL!)
    }()
    var model:BARPlayerModel?
    
    func setPlayerLayerFrame(_ frame:CGRect) {
        self.player.playerLayer?.frame = frame;
        self.frame = frame;
    }
    
    func play() {
        
    }
    
    func pause() {
        
    }
}
