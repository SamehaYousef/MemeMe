//
//  MemeTableViewController.swift
//  Meme1
//
//  Created by Sameha Yousef on 16/02/1441 AH.
//  Copyright © 1441 Sameha Yousef. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return allMemes.count
      }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")
           
        let meme = allMemes[indexPath.row]
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = String(meme.topText + " " + meme.bottomText)
        
        cell?.imageView?.image = meme.memedImage
       
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/5.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedController = self.storyboard?.instantiateViewController(withIdentifier: "DetailedMemeViewController") as! DetailedMemeViewController
               
               detailedController.meme = allMemes[(indexPath as NSIndexPath).row]
               

                  // Present the view controller using navigation
               navigationController!.pushViewController(detailedController, animated: true)
        
    }


}
