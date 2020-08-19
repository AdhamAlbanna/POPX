//
//  String+Extensions.swift
//  POPX
//
//  Created by Adham Albanna on 8/15/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import Foundation
import UIKit


extension String {

    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }

}
