//
//  SettingsVC.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit

class SettingsVC: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    
    //MARK: VIEW LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageViewPlaceholder.pulsate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
