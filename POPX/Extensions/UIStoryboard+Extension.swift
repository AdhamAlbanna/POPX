//
//  UIStoryboard+Extension.swift
//  POPX
//
//  Created by Adham Albanna on 7/30/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    func instantiateVC<T: UIViewController>() -> T? {
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
           print(name)
            return instantiateViewController(withIdentifier: name) as? T
        }
        return nil
    }

}
