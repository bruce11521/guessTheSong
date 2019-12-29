//
//  GuessSongViewController.swift
//  guessTheSong
//
//  Created by 林伯翰 on 2019/11/24.
//  Copyright © 2019 Bruce Lin. All rights reserved.
//

import UIKit
import AVKit

class GuessSongViewController: UIViewController {
    @IBOutlet weak var SongTitleLabel: UILabel!
    @IBOutlet weak var PlaySongBtn: UIButton!
    @IBOutlet weak var HintsBtn: UIButton!
    @IBOutlet weak var GuessSongBtn: UIButton!
    @IBOutlet weak var HintsTextView: UITextView!
    @IBOutlet weak var LvNumberImageView: UIImageView!
    @IBOutlet weak var missionTextView: UITextView!
    
    var ituneSong = [Song]()   //itune Song data
    /////func lvNumberCounter
    var lvNumber = 0
    /////func initSongData()
    let GuessSongLimit = 5
    var GuessSongQuestion = 0
    var songTemp = [Int]()
    var songQus = [Int]()
    var songQusStr = [String]()
    /////SongBtn
    var player: AVPlayer?
    var isPlaying = false
    /////HintsBtnPress
    var isGuessSong = false
    var HintsBtnCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        initSongData()
        self.missionTextView.text = ""
        self.missionTextView.textColor = UIColor.clear
            // Do any additional setup after loading the view.
    }
    
    func initSong(){
        
        
        let ituneApi = "https://itunes.apple.com/search?media=music&limit=1&entity=musicTrack&term="
        let urlStr = ituneApi + songDataBase[GuessSongQuestion].replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //print("urlStr:\(urlStr)")
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let songResults = try? decoder.decode(SongResults.self, from: data) {
                        self.ituneSong = songResults.results
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                    }
                }
            }.resume()
        }
        
        
    }
    func LvNumberCounter(){
        var lvNumberStr:String
        if lvNumber < 50{
            lvNumber += 1
            lvNumberStr = String(lvNumber) + ".circle"
            LvNumberImageView.image = UIImage(systemName: lvNumberStr)
        }
        
        
    }
    func initSongData(){
        songQus.removeAll()
        songTemp.removeAll()
        songQusStr.removeAll()
        for songNum in 0...songDataBase.count-1{
            songTemp.append(songNum)
        }
        for _ in 0...(GuessSongLimit-1){  //取出Temp中的GuessSongLimit個不重複的項目並存入Qus(為數字)中
            songQus.append(songTemp.remove(at: Int.random(in: 0...songTemp.count-1)))
        }
        GuessSongQuestion = songQus[Int.random(in: 0...songQus.count-1)]  //隨機取一個qus中的選項當題目
        initSong()
        for index in 0 ... songQus.count-1{
            if songDataBase[songQus[index]] == "范瑋琪"{
                let ss = songDataBase[songQus[index]] + "最初的夢想"
                songQusStr.append(ss)
            }else{
                songQusStr.append(songDataBase[songQus[index]])
            }
        }
        
        print("SongQus:\(songQus)\nGSQuestion:\(GuessSongQuestion)\nAnswer:\(songDataBase[GuessSongQuestion])\nsongQusStr:\(songQusStr)")
        
    }
    
    @IBAction func guessSongBtn(_ sender: Any) {
        //initSongData()
        //var songs = ituneSong[0] //設定songs為itunesApi中的資料
        let controller = UIAlertController(title: "只有一次機會歐！！！", message: "猜歌吧！", preferredStyle: .actionSheet)
        
        for GSitem in 0...GuessSongLimit-1{
            let action = UIAlertAction(title: songQusStr[GSitem] , style: .default ){ (action) in
                /*
                let ss = "\nAns:" + songDataBase[self.GuessSongQuestion]
                self.HintsTextView.text = action.title! + ss
                */
                if action.title == songDataBase[self.GuessSongQuestion]{
                    let ansController = UIAlertController(title: "答對了！", message: "正確答案是"+songDataBase[self.GuessSongQuestion], preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Good!", style: .default, handler: nil)
                    ansController.addAction(okAction)
                    self.present(ansController, animated: true, completion: nil)
                    self.missionTextView.text = "猜歌成功！"
                    self.missionTextView.textColor = UIColor.systemGreen
                }else{
                    let ansController = UIAlertController(title: "可惜了！", message: "你的選擇：" + action.title! + "\n正確答案："+songDataBase[self.GuessSongQuestion], preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "再接再厲！", style: .default, handler: nil)
                    ansController.addAction(okAction)
                    self.present(ansController, animated: true, completion: nil)
                    self.missionTextView.text = "猜歌失敗！"
                    self.missionTextView.textColor = UIColor.systemRed
                    self.player?.pause()
                }
                
                self.LvNumberCounter()
                self.HintsTextView.text = nil  //猜過後，清空提示
                self.HintsBtnCounter = 0 //重新計數提示
                self.initSongData() //選取選項後重置題目
                self.isGuessSong = false //猜完歌後重新設置提示遮罩
                
                
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "再聽一次歌曲，再想想？", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func PlaySontBtnPress(_ sender: Any) {
        
        let song = ituneSong[0]
        player = AVPlayer(url: song.previewUrl)
        player?.play()
        isGuessSong = true
        
        self.missionTextView.text = ""
        self.missionTextView.textColor = UIColor.clear
        
        
            if lvNumber == 50{
                let LVController = UIAlertController(title: "恭喜破完第一大關！後面關卡開發中，敬請期待！", message: "重新計算關卡！" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
                LVController.addAction(okAction)
                self.present(LVController, animated: true, completion: nil)
                lvNumber = 0
                LvNumberImageView.image = UIImage(systemName: String(lvNumber) + ".circle")
            }
    }
    
    @IBAction func HintsBtnPress(_ sender: Any) {
        var hintsStr = ""
        let tempStr = songDataBase[GuessSongQuestion]
        let strLimit = tempStr.count //答案字串總數量，防止提示字串溢位
        //let endIndex = tempStr.index(tempStr.startIndex, offsetBy: item)
        //(tempStr.count<=strLimit) ? HintsBtnCounter+1:tempStr.count
        if isGuessSong{  //判斷是否先聽過歌曲！
            switch HintsBtnCounter{
            case 0:
                print((HintsBtnCounter+1<=strLimit ? HintsBtnCounter+1 : tempStr.count-1))
                hintsStr = "提示第一次\n" + tempStr[tempStr.startIndex...(tempStr.index(tempStr.startIndex, offsetBy: ((HintsBtnCounter+1<strLimit) ? HintsBtnCounter+1:tempStr.count-1) ))]
                HintsBtnCounter += 1
                break
            case 1:
                print("HintsBtnCounter=\(HintsBtnCounter),\(HintsBtnCounter+1<strLimit ? HintsBtnCounter+1 : tempStr.count-1)")
                
                hintsStr = "提示第二次\n" + tempStr[tempStr.startIndex...(tempStr.index(tempStr.startIndex, offsetBy: ((HintsBtnCounter+1<strLimit) ? HintsBtnCounter+1:tempStr.count-1) ))]
                HintsBtnCounter += 1
                break
            case 2:
                
                print("HintsBtnCounter=\(HintsBtnCounter),\(HintsBtnCounter+1<strLimit ? HintsBtnCounter+1 : tempStr.count-1)")
                
                hintsStr = "提示第三次\n" + tempStr[tempStr.startIndex...(tempStr.index(tempStr.startIndex, offsetBy: ((HintsBtnCounter+1<strLimit) ? HintsBtnCounter+1:tempStr.count-1) ))]
                HintsBtnCounter += 1
                break
            default:
                print("HintsBtnCounter=\(HintsBtnCounter),\(HintsBtnCounter+1<strLimit ? HintsBtnCounter+1 : tempStr.count-1)")
                
                hintsStr = "用光提示囉！！\n" + tempStr[tempStr.startIndex...(tempStr.index(tempStr.startIndex, offsetBy: ((HintsBtnCounter+1<strLimit) ? HintsBtnCounter+1:tempStr.count-1) ))]
                break
            }
            HintsTextView.text = hintsStr
        }else{
            HintsTextView.text = "別急得看提示！\n先聽歌猜猜看嘛！"
        }
        
        //initSongData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
