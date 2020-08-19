//
//  UIExtension.swift
//  POPX
//
//  Created by Adham Albanna on 7/30/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import Foundation



extension UIView {

    @IBInspectable var color :UIColor {
        set{
            self.layer.borderColor = newValue.cgColor
        }
        
        get{
            return UIColor.init()
        }
        
    }
    
    
    @IBInspectable var border :CGFloat {
        set{
            self.layer.borderWidth = newValue
        }
        
        get{
            return self.layer.borderWidth
        }
        
    }
    
    @IBInspectable var reduis :CGFloat {
        set{
            self.layer.cornerRadius = newValue
        }
        
        get{
            return self.layer.cornerRadius
        }
        
    }
    

        func layerGradient() {
            let layer : CAGradientLayer = CAGradientLayer()
            layer.frame.size = self.frame.size
            layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
            layer.cornerRadius = CGFloat(frame.width / 20)

            let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
            let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
            let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
            let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
            let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
            let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
            let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor

            layer.colors = [color0,color1,color2,color3,color4,color5,color6]
            self.layer.insertSublayer(layer, at: 0)
        }

       
    
    

}

extension UIViewController {
  func toastMessage(_ message: String){
    guard let window = UIApplication.shared.keyWindow else {return}
    let messageLbl = UILabel()
    messageLbl.text = message
    messageLbl.textAlignment = .center
    messageLbl.font = UIFont.systemFont(ofSize: 12)
    messageLbl.textColor = .white
    messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)

    let textSize:CGSize = messageLbl.intrinsicContentSize
    let labelWidth = min(textSize.width, window.frame.width - 40)

    messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
    messageLbl.center.x = window.center.x
    messageLbl.layer.cornerRadius = messageLbl.frame.height/2
    messageLbl.layer.masksToBounds = true
    window.addSubview(messageLbl)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

    UIView.animate(withDuration: 1, animations: {
        messageLbl.alpha = 0
    }) { (_) in
        messageLbl.removeFromSuperview()
    }
    }
}}
