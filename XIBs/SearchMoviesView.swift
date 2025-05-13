//
//  SearchMoviesView.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit
import Foundation

class SearchMoviesView: UIView {
    
    //MARK: OUTLETS
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelPlaceholder: UILabel!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    
    //MARK: PROPERTIES
    var placeholderMessage: String = ""
    var placeholderType: PlaceholderType = .noMovies
  
    //MARK: LIFECYCLE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    class func initView(frame: CGRect) -> SearchMoviesView? {
        
        let view = Bundle.main.loadNibNamed("SearchMoviesView", owner: self, options: nil)?.first as? SearchMoviesView
        view?.frame = frame
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupPlaceholders()
    }
    
    func setupPlaceholders() {
        self.labelPlaceholder.text = placeholderMessage
        self.imageViewPlaceholder.image = UIImage(named: placeholderType.placeholderImage)
    }
}


