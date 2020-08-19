//
//  ChatVC.swift
//  POPX
//
//  Created by Adham Albanna on 8/3/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatVC: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    var ListMessages=Array<Message>()
    @IBOutlet weak var massegeToSendTF: UITextField!
    let userName = Auth.auth().currentUser!
    let ref = Database.database().reference()
    var imagePicker:UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        LoadMessages()
        
        imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
        
    }
    
    
    
    @IBAction func btnSendChat(_ sender: Any) {
        let msg = ["userName":userName.email ?? "","date":ServerValue.timestamp(),"text":massegeToSendTF.text ?? ""] as [String : Any]
        
        let firebaseMsg = ref.child("msg").childByAutoId()
        firebaseMsg.setValue(msg)
        massegeToSendTF.text = ""
    }
    
    func AddSnap(ImagPath:String){
        let msg=[
            "UserName":userName.email ?? "user",
            "text":massegeToSendTF.text ?? "no-message",
            "postDate": ServerValue.timestamp(),
            "ImagePath":ImagPath
            ] as [String:Any]
        let FirebaseMessage=self.ref.child("msg").childByAutoId()
        FirebaseMessage.setValue(msg)
        massegeToSendTF.text=""

    }
    
    
    func LoadMessages(){
        self.ref.child("msg").queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            self.ListMessages.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? [String:AnyObject]{
                        self.setMessage(msgId: snap.key, msgData: postDict)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func setMessage(msgId:String,msgData:[String:AnyObject]){
        var text:String!
        var userName:String!
        var postDate:String!
        var imagePath:String!
        if let userName1 = msgData["userName"] as? String {
            userName=userName1
        } else {
            userName="no-data"
        }
        if let postDate1 = msgData["date"] as? String {
            postDate=postDate1
        }else{
            postDate="no-data"
        }
        if let text1 = msgData["text"] as? String{
            text=text1
        }
        if let imagePath1 = msgData["imagePath"] as? String{
            imagePath=imagePath1
        }else{
            imagePath="no-data"
        }
        self.ListMessages.append(Message(text: text, userName: userName, postDate: postDate, imagePath: imagePath))
        
    }
    
    
    @IBAction func btnLoadImages(_ sender: Any) {
        presentPhotoActionSheet()
        
    }
}



extension ChatVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTableViewCell=tableView.dequeueReusableCell(withIdentifier: "cellText",for: indexPath) as! ChatTableViewCell
        cell.setText(msg: ListMessages[indexPath.row].text)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
                
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil else {
            return
        }

        //self.imageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

