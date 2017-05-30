//
//  StartViewController.swift
//  SwiftGetFruits
//
//  Created by ChenQianPing on 16/7/24.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playBgMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.stop()
    }
    
    // 隐藏顶部状态栏
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func playBgMusic() {
        // 指定音乐路径
        let musicPath = Bundle.main.path(forResource: "startMusic", ofType: "wav")
        let url = URL(fileURLWithPath: musicPath!)
        audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1  // 设置音乐播放次数,-1为循环播放
        audioPlayer.volume = 1          // 设置音乐音量,可用范围为0~1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    
}

