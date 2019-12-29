//
//  mainMenuViewController.swift
//  guessTheSong
//
//  Created by 林伯翰 on 2019/11/24.
//  Copyright © 2019 Bruce Lin. All rights reserved.
//

import UIKit

class mainMenuViewController: UIViewController {

    @IBOutlet weak var StartGameImageView: UIImageView!
    @IBOutlet weak var StartGameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MusicBg")!)
        // Do any additional setup after loading the view.
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
