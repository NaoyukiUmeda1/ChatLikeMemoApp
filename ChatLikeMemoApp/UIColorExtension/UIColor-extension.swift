//
//  UIColor-extension.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit

extension UIColor {
    
    
    static func rgb(red: CGFloat, green: CGFloat , blue: CGFloat) -> UIColor{
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
}
