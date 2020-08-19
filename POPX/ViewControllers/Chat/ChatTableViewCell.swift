//
//  ChatTableViewCell.swift
//  POPX
//
//  Created by Adham Albanna on 8/17/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var txtText: UILabel!
    @IBOutlet weak var cellTextImg: UIImageView!
    
    func setText(msg:String?){
        txtText.text = msg
    }
    func setTextWithImage(msg:Message){
        txtText.text="\(msg.userName!):\(msg.text!)"
        SetImage(url: msg.imagePath!)
       //self.iv_Image_post.layer.cornerRadius = 25;
      // self.iv_Image_post.layer.masksToBounds = true;
    }
    
    func SetImage(url:String){
        
        let storageRef = Storage.storage().reference(forURL: "gs://popx-random.appspot.com")

        let islandRef = storageRef.child(url)
        
        islandRef.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                // let image = UIImage(data: data!)
                self.cellTextImg.image = UIImage(data: data!)
            }
        }
    }

}
