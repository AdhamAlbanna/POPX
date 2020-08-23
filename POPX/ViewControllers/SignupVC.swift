//
//  SignupVC.swift
//  POPX
//
//  Created by Adham Albanna on 7/30/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class SignupVC: UIViewController {
    
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var usernameUIView : UIView!
    @IBOutlet weak var emailUIView : UIView!
    @IBOutlet weak var phoneUIView : UIView!
    @IBOutlet weak var passwordUIView : UIView!
    @IBOutlet weak var confirmPasswordUIView : UIView!
    
    let spinner = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setDatePicker()
    }
    
    
    
    @IBAction func btnToLoginAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getUserAge() -> Int {
        let currnetDate = Date()
        let userBD = datePicker.date
        let calender = Calendar.current
        let component = calender.dateComponents([Calendar.Component.year], from: userBD,to: currnetDate)
        return component.year!
    }
    
    func setDatePicker(){
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -17
        let maxDate = calendar.date(byAdding: comps, to: Date())
        comps.year = -100
        let minDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
    }
    
    func segmentedGender() -> String {
        var genderTayp :String!
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            genderTayp = "Male"
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            genderTayp = "Female"
        }
        return genderTayp
    }
    
    
    @IBAction func btnRegisterAction(_ sender: Any) {
                
        if (usernameTF.text?.isEmpty==true) || (emailTF.text!.isEmpty) || (phoneTF.text?.isEmpty==true) || (passwordTF.text?.isEmpty==true) || (confirmPasswordTF.text?.isEmpty==true) {
            
            if (usernameTF.text!.isEmpty) {
                usernameUIView.color = .red
            }else{
                usernameUIView.color = .lightGray
            }
            
            if (emailTF.text?.isEmpty==true) {
                emailUIView.color = .red
            }else{
                emailUIView.color = .lightGray
            }
            
            if (phoneTF.text?.isEmpty==true) {
                phoneUIView.color = .red
            }else{
                phoneUIView.color = .lightGray
            }
            
            if (passwordTF.text?.isEmpty==true) {
                passwordUIView.color = .red
            }else{
                passwordUIView.color = .lightGray
            }
            
            if (confirmPasswordTF.text?.isEmpty==true) {
                confirmPasswordUIView.color = .red
            }else{
                confirmPasswordUIView.color = .lightGray
            }
            
        }else {
            creatAccount(ussername: usernameTF.text!, email: emailTF.text!, phone: phoneTF.text!, password: passwordTF.text!, age: getUserAge(), gender: segmentedGender())
        }
    }
    
    func creatAccount(ussername:String,email:String,phone:String,password:String,age:Int,gender:String){
        spinner.show(in: view)
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if error != nil {
                self.spinner.dismiss()
                let alert = UIAlertController(title: "SignUp field", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error!.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else { return }
            let values = ["username":ussername,"email":email,"phone":phone,"password":password,"age":age,"gender":gender,"likes":0] as [String : Any]
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (erorr, ref) in
                if let error = error {
                    print("Error to update values : ",error.localizedDescription)
                    return
                }
            }
            self.spinner.dismiss()
            //user register sucsseful
            self.dismiss(animated: true, completion: nil)
        }
    }
}
