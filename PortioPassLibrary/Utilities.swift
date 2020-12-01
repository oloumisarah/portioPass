//
//  Utilities.swift
//  PortioPass
//
//  Created by sarah oloumi on 2020-10-31.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//  With Reference to https://github.com/soonin/IOS-Swift-TextGradientColors

import Foundation
import UIKit

extension UILabel {
    
    public func portioGradientColor(gradientColors : [UIColor] = [UIColor(white: 0, alpha: 0.95) ,  UIColor(white: 0, alpha: 0.6) ]) {
        
           let size = CGSize(width: intrinsicContentSize.width, height: 1)
           
           // Begin image context
           UIGraphicsBeginImageContextWithOptions(size, false, 0)
          
           defer { UIGraphicsEndImageContext() }
           guard let context = UIGraphicsGetCurrentContext() else { return }
           
           // Create an array of colors for the gradient
           var  gradientScale : [CGColor] = []
           for color in gradientColors {
            gradientScale.append(color.cgColor)
           }
           guard let gradient = CGGradient(
               colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientScale as CFArray,
               locations: nil
               ) else { return }
           
           // Draw the gradient in image context
           context.drawLinearGradient(
               gradient,
               start: CGPoint.zero,
            end: CGPoint(x: 0, y: 1.0), // Vertical gradient
               options: []
           )
        // Create an image (like a background) from the gradient and set it to the textColor.
           if let image = UIGraphicsGetImageFromCurrentImageContext() {
               self.textColor = UIColor(patternImage: image)
           }
       }
}

extension UITextField {
  func useUnderline() -> Void {
    let border = CALayer()
    let borderWidth = CGFloat(2.0) // Border Width
    border.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6862745098, alpha: 1)
    border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
    border.borderWidth = borderWidth
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
}

class Utilities {
    // Checks Password strength w reference to https://medium.com/swlh/password-validation-in-swift-5-3de161569910
    static func isPasswordGood(_ password : String) -> Bool {
        
        let userPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{10,}")
        // returns true if password is strong enough
        return userPassword.evaluate(with: password)
    }
}
