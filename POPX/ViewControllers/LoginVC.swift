//
//  LoginVC.swift
//  POPX
//
//  Created by Adham Albanna on 7/30/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import JGProgressHUD


class LoginVC: UIViewController{
    
    let userDefault = UserDefaults()
    let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnFbView: UIView!
    
    @IBOutlet weak var emailUIView : UIView!
    @IBOutlet weak var passwordUIView : UIView!
    
    @IBOutlet weak var myBytton : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        //myBytton.isUserInteractionEnabled  = true
        
        //myBytton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myButtonAction)))
        
    }
    
    
    @objc func myButtonAction(){
        
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        if (emailTF.text?.isEmpty==true) || (passwordTF.text?.isEmpty==true) {
            
            if (emailTF.text?.isEmpty==true) {
                emailUIView.color = .red
            }else{
                emailUIView.color = .lightGray
            }
            
            if (passwordTF.text?.isEmpty==true) {
                passwordUIView.color = .red
            }else{
                passwordUIView.color = .lightGray
            }
            
        }else {
        logUserIn(whitEmail: emailTF.text!, password: passwordTF.text!)
        }
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        let signUpVC = self.storyboard!.instantiateViewController(identifier: "SignupVC")
        present(signUpVC, animated: true, completion: nil)
        
    }
    
    
    func logUserIn(whitEmail email:String,password:String){
        spinner.show(in: view)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.spinner.dismiss()
                let alert = UIAlertController(title: "login field", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Failed to signin user :",error.localizedDescription)
                return
            }
            self.spinner.dismiss()
            let MainVC = self.storyboard!.instantiateViewController(identifier: "UITabBarController")
            self.present(MainVC, animated: true, completion: nil)
            print("login success")
            self.toastMessage("Login Success")
            self.userDefault.set(true, forKey: "usersignin")
            self.userDefault.synchronize()
        }
    }
}


extension LoginVC: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }

        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":
                                                            "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)

        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String: Any],
                error == nil else {
                    print("Failed to make facebook graph request")
                    return
            }

            print(result)

            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let pictureUrl = data["url"] as? String else {
                    print("Faield to get email and name from fb result")
                    return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")


            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    return
                    
                }
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }

    
    
    @IBAction func startLoginGoogle(){
        
    }
}
