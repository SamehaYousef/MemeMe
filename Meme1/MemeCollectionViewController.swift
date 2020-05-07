//
//  MemeCollectionViewController.swift
//  Meme1
//
//  Created by Sameha Yousef on 16/02/1441 AH.
//  Copyright © 1441 Sameha Yousef. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {

    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let space:CGFloat = 3.0
        
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()

    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        //MemeCollectionViewController
        let meme = self.allMemes[indexPath.item]
        
        cell.imageView.image = meme.memedImage
        cell.memeTitle.text = String(meme.topText + " " + meme.bottomText)
        
        return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedMemeViewController") as! DetailedMemeViewController
        
        // Present the view controller using navigation
        
        detailedController.meme = allMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailedController, animated: true)
    }



}
