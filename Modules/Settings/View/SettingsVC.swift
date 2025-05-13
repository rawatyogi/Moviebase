//
//  SettingsVC.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
