//
//  AppLoader.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 10/05/25.
//

import UIKit
import Foundation

final class AppLoader {
    
    private init() {}
    static let shared = AppLoader()
   
    //view to show as loader
    var viewMain: UIView?
    var indicator: UIActivityIndicatorView?
    
    //MARK: SHOW LOADER
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene , let sceneDel = windowScene.delegate as? SceneDelegate, let window = sceneDel.window else {
                return
            }
            
            if self?.viewMain !=  nil { return }
            
            let view = UIView(frame: window.frame)
            view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            let loader = UIActivityIndicatorView(style: .large)
            loader.center = view.center
            loader.color = UIColor().colorWithHexString(hex: "#FAAD2A")
            loader.startAnimating()
            
            view.addSubview(loader)
            window.addSubview(view)
            
            self?.viewMain = view
            self?.indicator = loader
        }
    }
    
    //MARK: STOP LOADER
    func stopLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator?.stopAnimating()
            self?.viewMain?.removeFromSuperview()
            
            self?.viewMain = nil
            self?.indicator = nil
        }
    }
}
