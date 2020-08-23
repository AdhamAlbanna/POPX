//
//  MainVC.swift
//  POPX
//
//  Created by Adham Albanna on 8/3/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FBSDKLoginKit
import CodableFirebase




class MainVC: UIViewController {
    

    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var imgUser:UIImageView!
    @IBOutlet weak var txtLikes: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var uiView:UIView!
    @IBOutlet weak var uiViewCH: UIView!
    
    let userRef = Database.database().reference(withPath: "online")
    let dataRef = Database.database().reference().child("users")
    

    
    let user = Auth.auth().currentUser!
    
    var uid = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        uiView.layerGradient()
        uiViewCH.layerGradient()
        setUserOnline()
        updateOnlineUser()
        getOnlineUserId()
        SetImgUser()
        lblUsername.text = UserDefaults.standard.string(forKey: "NAME")
        imgUser.downloaded(from: UserDefaults.standard.string(forKey: "imgUserURL") ?? "")
        let userEmail = Auth.auth().currentUser?.email
        let userPhoto = Auth.auth().currentUser?.photoURL
        let firstChar = "a"
        let singleName = firstChar + userEmail!
        lblUsername.text = singleName.slice(from: "a", to: "@")
        if userPhoto != nil {
            imgUser.downloaded(from: userPhoto!)
        }
        
    }
    
    func SetImgUser(){
        let images: [UIImage] = [#imageLiteral(resourceName: "Mike"),#imageLiteral(resourceName: "Alien"),#imageLiteral(resourceName: "Mummy"),#imageLiteral(resourceName: "Pumpkin"),#imageLiteral(resourceName: "Slimer"),#imageLiteral(resourceName: "Jack Skellington"),#imageLiteral(resourceName: "Freddie"),#imageLiteral(resourceName: "Devil"),#imageLiteral(resourceName: "Ghost"),#imageLiteral(resourceName: "Jason"),#imageLiteral(resourceName: "Devil"),#imageLiteral(resourceName: "Casper"),#imageLiteral(resourceName: "Frankenstein")]
        let randomImage = images.shuffled().randomElement()
        imgUser.image = randomImage
    }
    
    @IBAction func btnSginOut() {
        
        GIDSignIn.sharedInstance()?.signOut()
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        let onlineRef = userRef.child(user.uid)
        onlineRef.removeValue()
        LoginManager().logOut()
        resetUserDefaults()
        
        let LoginVC = self.storyboard!.instantiateViewController(identifier: "LoginVC")
        self.present(LoginVC, animated: true, completion: nil)
    }
    
    @IBAction func btnStartChat(){
        getOnlineUserId()
        SetImgUser()
        getUserData()
        
        let ChatVC = self.storyboard!.instantiateViewController(identifier: "ChatVC")
        present(ChatVC, animated: true, completion: nil)
    }
    
    
    func setUserOnline(){
        let currentUserRef = self.userRef.child(user.uid)
        currentUserRef.setValue(self.user.email)
        currentUserRef.onDisconnectRemoveValue()
    }
    
    func updateOnlineUser() {
        userRef.observe(.value) { (snapshot) in
            if snapshot.exists(){
                self.toastMessage(snapshot.childrenCount.description)
            } else {
                self.toastMessage("No One IS Online")
            }
        }
    }
    
    
    func getOnlineUserId(){
        let ref = Database.database().reference()
        ref.child("online").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get users key
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let post = snap.key as String?{
                        self.uid.insert(post)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func getUserData() {
        let ref = Database.database().reference()
        ref.child("users").child("\(user.uid)").child("age").observeSingleEvent(of: .value, with: { (snapshot) in
            if let age = snapshot.value as? String {
                print( "snapshot: \(age)")
                self.txtAge.text = String(age)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").child("\(user.uid)").child("gender").observeSingleEvent(of: .value, with: { (snapshot) in
            if let gender = snapshot.value as? String {
                print( "snapshot: \(gender)")
                self.txtGender.text = gender
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").child("\(user.uid)").child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let likes = snapshot.value as? String {
                print( "snapshot: \(likes)")
                self.txtGender.text = likes
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func resetUserDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    
    
//    func getDataToDb() {
//
//        AppDelegate.db.collection("RealEstate").getDocuments { (snapshot, err) in
//            for i in snapshot!.documents{
//
//                AppDelegate.db.collection("RealEstate").document(i.documentID).collection(i.documentID).addSnapshotListener(includeMetadataChanges: true, listener: { (snapshot, er) in
//                    self.getData = []
//                    for (i) in (snapshot?.documents)! {
//                        let jsonData = try! JSONSerialization.data(withJSONObject: i.data() ?? [:], options: [])
//                        let users = try! JSONDecoder().decode(AddBuilding.self, from: jsonData )
//                        print(users)
//                        self.getData.append(users)
//
//                    }
//                    self.collectionVC.reloadData()
//                })
//
//
//            }
//
//
//        }
//    }
    
}
