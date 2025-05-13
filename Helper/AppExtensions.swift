//
//  AppExtensions.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit
import Foundation

//MARK: TABLEVIEW EXTENSIONS
extension UITableView {
    func registerCell(identifier: UITableViewCell.Type) {
        let id = String(describing: identifier)
        self.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
    
    func setPlaceholderView(message: String, type: PlaceholderType) {
        self.backgroundView = PlaceholderViewFactory().getPlaceholderViews(type: type, placeholderMessage: message)
    }
    
    func resetPlaceholderView() {
        self.backgroundView = nil
    }
}


//MARK: UIVIEW EXTENSIONS FOR CUSTOMISTAIONS
extension UIView {
    func makeRounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func showView() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func hideView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }

}

//MARK: UIVIEW EXTENSIONS FOR ACCESIBILITY
extension UIView {
    
    class func loadViewFromNib() -> UIView {
        let nibName = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView else {
            fatalError("Could not load nib with name \(nibName)")
        }
        return view
    }
}

//MARK: UICOLOR EXTENSIONS
extension UIColor {
    
    func colorWithHexString(hex: String) -> UIColor {
        let alpha: CGFloat = 1
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let hexSubstring = hex.dropFirst()
        
        if let rgb = UInt(hexSubstring, radix: 16) {
            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return .black
        }
    }
}


extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: VIEW ANIMATIONS
extension UIView {
    func pulsate() {

        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 0.87
        pulseAnimation.toValue = 1.15
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        self.layer.add(pulseAnimation, forKey: "pulsing")
    }
    
    func stopPulsating() {
        self.layer.removeAnimation(forKey: "pulsing")
    }
}
