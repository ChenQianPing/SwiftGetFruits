//
//  ViewController.swift
//  SwiftGetFruits
//
//  Created by ChenQianPing on 16/7/24.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import UIKit
import AVFoundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    @IBOutlet weak var markLbl: UILabel!
    
    var timer: Timer!
    var boomTimer: Timer!
    var belowImg: UIImageView!
    var audioPlayer: AVAudioPlayer!
    var boomAudioPlayer: AVAudioPlayer!
    
    var leftTime: Int = 99999
    var boomLeftTime: Int = 999
    var mark: Int = 0
    var GameOn: Bool!    // true为正在游,false为游戏结束
    
    var index: UInt32!
    var boomIndex: UInt32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        belowImg = UIImageView(frame: CGRect(x: self.view.frame.size.width/2-35, y: 0.85*self.view.frame.size.height+10, width: 70, height: 36))
        belowImg.image = UIImage(named: "bascket_w.png")
        self.view.addSubview(belowImg)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        markLbl.text = "当前分数:" + String(mark)
        
        GameOn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playBgMusic()
        // 启用计时器,控制每秒执行一次tickDown方法
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                                       target:self,selector:#selector(ViewController.tickDown),
                                                       userInfo:nil,repeats:true)
        
        // 启用计时器,控制每秒执行一次tickDown方法
        boomTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                                           target:self,selector:#selector(ViewController.boomDown),
                                                           userInfo:nil,repeats:true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.stop()
        if GameOn == true {
            timer.invalidate()
            timer = nil
            boomTimer.invalidate()
            boomTimer = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playBgMusic() {
        let musicPath = Bundle.main.path(forResource: "bgMusic", ofType: "wav")
        // 指定音乐路径
        let url = URL(fileURLWithPath: musicPath!)
        audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1  // 设置音乐播放次数,-1为循环播放
        audioPlayer.volume = 1          // 设置音乐音量,可用范围为0~1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playBoomMusic() {
        let musicPath = Bundle.main.path(forResource: "boomMusic", ofType: "wav")
        // 指定音乐路径
        let url = URL(fileURLWithPath: musicPath!)
        boomAudioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        boomAudioPlayer.numberOfLoops = 1  // 设置音乐播放次数,-1为循环播放
        boomAudioPlayer.volume = 1         // 设置音乐音量,可用范围为0~1
        boomAudioPlayer.prepareToPlay()
        boomAudioPlayer.play()
    }
    
    @IBAction func backBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    // 隐藏顶部状态栏
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    // Pan拖动手势
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        // 得到拖的过程中的xy坐标
        let location : CGPoint = sender.location(in: self.view)
        belowImg.frame = CGRect(x: location.x-35, y: belowImg.frame.origin.y, width: belowImg.frame.size.width, height: belowImg.frame.size.height)
//        print(belowImg.frame)
    }
    
    // Tap点手势
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let location : CGPoint = sender.location(in: self.view)
        belowImg.frame = CGRect(x: location.x-35, y: belowImg.frame.origin.y, width: belowImg.frame.size.width, height: belowImg.frame.size.height)
//        print(belowImg.frame)
    }
    
    
    // MARK:- 生成水果
    func show() {
        
        print("index=\(index)")
        var img = UIImageView(frame: CGRect(x: CGFloat(index), y: 0, width: 50, height: 50)) {
            willSet(frameChange) {
            }
        }
        
        img.image = UIImage(contentsOfFile: Bundle.main.path(forResource: String(arc4random_uniform(5)), ofType:"png")!)
        
        print("arc4random_uniform=\(arc4random_uniform(5))")
        
        img.tag = leftTime
        
        print("img.tag=\(leftTime)")
        
        self.view.addSubview(img)
        
        UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
            img.frame = CGRect(x: CGFloat(self.index), y: SCREEN_HEIGHT, width: 50, height: 50)
            }, completion: nil)
    }
    
    func boomShow() {
        var img = UIImageView(frame: CGRect(x: CGFloat(boomIndex), y: 0, width: 50, height: 80)) {
            willSet(frameChange) {
                
            }
        }
        
        img.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "boom", ofType:"png")!)
        img.tag = boomLeftTime
        self.view.addSubview(img)
        
        if arc4random_uniform(2) == 0 {
            UIView.animate(withDuration: 2.5, delay: 0, options: .curveLinear, animations: {
                img.frame = CGRect(x: CGFloat(self.boomIndex)-50, y: SCREEN_HEIGHT, width: 50, height: 80)
                }, completion: nil)
        }else {
            UIView.animate(withDuration: 2.5, delay: 0, options: .curveLinear, animations: {
                img.frame = CGRect(x: CGFloat(self.boomIndex)+50, y: SCREEN_HEIGHT, width: 50, height: 80)
                }, completion: nil)
        }
    }
    
    func boomDown() {
        if GameOn == true {
            // 如果剩余时间小于等于0
            if boomLeftTime <= 0 {
                // 取消定时器
                boomTimer.invalidate()
            }
            
            if boomLeftTime <= 997 {
                let img = self.view.viewWithTag(boomLeftTime+1) as! UIImageView
                
                if img.frame.origin.x > belowImg.frame.origin.x-35 {
                    if img.frame.origin.x < belowImg.frame.origin.x+55 {
                        let aimg = self.view.viewWithTag(boomLeftTime+1) as! UIImageView
                        aimg.isHidden = true;
                        
                        mark = mark-5
                        playBoomMusic()
                        gameOver()
                    }
                }
            }
            
            if boomLeftTime <= 994 {
                let img = self.view.viewWithTag(boomLeftTime+4) as! UIImageView
                img.removeFromSuperview()
            }
            
            boomLeftTime -= 1
            // 修改UIDatePicker的剩余时间
            boomIndex = UInt32(SCREEN_WIDTH*0.87)
            boomIndex = arc4random_uniform(boomIndex)
            boomShow()
        } else {
            boomTimer.invalidate()
            boomTimer = nil
        }
    }
    
    func tickDown() {
        if GameOn == true {
            // 如果剩余时间小于等于0
            if leftTime <= 0 {
                // 取消定时器
                timer.invalidate()
            }
            
            if leftTime <= 99995 {
                let img = self.view.viewWithTag(leftTime+3) as! UIImageView
                
                if img.frame.origin.x > belowImg.frame.origin.x-35 {
                    if img.frame.origin.x < belowImg.frame.origin.x+55 {
                        let aimg = self.view.viewWithTag(leftTime+3) as! UIImageView
                        aimg.isHidden = true;
                        
                        mark = mark+1
                        markLbl.text = "当前分数:" + String(mark)
                    } else {
                        mark = mark-1
                        gameOver()
                    }
                } else {
                    mark = mark-1
                    gameOver()
                }
            }
            
            if leftTime <= 99994 {
                let img = self.view.viewWithTag(leftTime+4) as! UIImageView
                img.removeFromSuperview()
            }
            
            leftTime -= 1
            // 修改UIDatePicker的剩余时间
            index = UInt32(SCREEN_WIDTH*0.87)
            index = arc4random_uniform(index)
            show()
        }else {
            timer.invalidate()
            timer = nil
        }
    }
    
    func gameOver() {
        if mark < 0 {
            GameOn = false
            self.mark = 0
            self.markLbl.text = "当前分数:" + String(self.mark)
            
            let alertController = UIAlertController(title: "Game Over",
                                                    message: "是否继续?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            })
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.destructive, handler: {
                action in
                self.GameOn = true
                self.leftTime = 99999
                self.boomLeftTime = 999
                self.markLbl.text = "当前分数:" + String(self.mark)
                
                // 启用计时器,控制每秒执行一次tickDown方法
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                    target:self,selector:#selector(ViewController.tickDown),
                    userInfo:nil,repeats:true)
                
                self.boomTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                    target:self,selector:#selector(ViewController.boomDown),
                    userInfo:nil,repeats:true)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            markLbl.text = "当前分数:" + String(mark)
        }
    }
}
