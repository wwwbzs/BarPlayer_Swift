//
//  Player.swift
//  Player
//
//  Created by Barray on 2017/5/3.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import AVFoundation




class Player: NSObject {
    
    var totalTime:CMTime?{
        get{
            return self.playerItem?.duration
        }
    }
    var currtentTime:CMTime?{
        get{
            return self.playerItem?.currentTime()
        }
    }
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playerLayer:AVPlayerLayer?
    var asset:AVURLAsset?
    
    static func player(_ url:URL) -> Player {
        let player = Player()
        player.asset = AVURLAsset(url: url)
        
        player.playerItem = AVPlayerItem(asset: player.asset!)
        player.player = AVPlayer(playerItem: player.playerItem)
        player.playerLayer = AVPlayerLayer(player: player.player)
        return player
    }
    
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    /// 懒加载，文件
    ///
    /// - Parameters:
    ///   - forKeys: 文件属性
    ///   - completionHandler: 加载成功后处理
    func loadValuesAsynchronously(forKeys:[String], completionHandler:(()-> Void)?) -> Void {
        self.asset?.loadValuesAsynchronously(forKeys: forKeys, completionHandler: completionHandler)
    }
    
    func addObserver(to playerItem:AVPlayerItem) {
         //监控状态属性
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.status, options: NSKeyValueObservingOptions.new, context: nil)
        //监控网络加载情况属性
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.loadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
        //监听播放的区域缓存是否为空
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.playbackBufferEmpty, options: NSKeyValueObservingOptions.new, context: nil)
        //缓存可以播放的时候调用
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.playbackLikelyToKeepUp, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func removeObserver(from playerItem:AVPlayerItem) {
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.status)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.loadedTimeRanges)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.playbackBufferEmpty)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.playbackLikelyToKeepUp)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case ObserverKeyPath.status:
            let status = change?[NSKeyValueChangeKey.newKey] as! AVPlayerItemStatus
            if status == AVPlayerItemStatus.readyToPlay {
                
            }
        case ObserverKeyPath.loadedTimeRanges: break
            
        default: break
            
        }
    }
}



fileprivate struct ObserverKeyPath{
    static let status = "status"
    static let loadedTimeRanges = "loadedTimeRanges"
    static let playbackBufferEmpty = "playbackBufferEmpty"
    static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
}
