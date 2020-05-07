//
//  DetailedMemeViewController.swift
//  Meme1
//
//  Created by Sameha Yousef on 18/02/1441 AH.
//  Copyright © 1441 Sameha Yousef. All rights reserved.
//

import UIKit

class DetailedMemeViewController: UIViewController {
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        showMeme.image = meme.memedImage

    }
    @IBOutlet weak var showMeme: UIImageView!
    
    
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
  

    override func viewDidDisappear(_ animated: Bool) {
        // self.tabBarController?.tabBar.isHidden = false

    }

}
