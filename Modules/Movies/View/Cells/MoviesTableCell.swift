//
//  MoviesTableCell.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit
import Kingfisher

class MoviesTableCell: UITableViewCell {

    //MARK: IBOUTLETS
    @IBOutlet weak var viewMask: UIView!
    @IBOutlet weak var labelRating: UILabel! //used for runtime
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var labelMovieDescription: UILabel!
    @IBOutlet weak var labelMovieReleaseYear: UILabel!
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    
    //MARK: LIFECYCLE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.backgroundColor = UIColor().colorWithHexString(hex: "#151F28")
        viewContainer.makeRounded(radius:  DeviceType.shared.iPhoneDevice ? 6.0 : 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: SETUP SEARCHED MOVIE DATA
    func setupMoviesDataOnCell(movieData: MoviesModel) {
       
        labelRating.text = movieData.runtime
        labelLanguage.text = movieData.language
        labelMovieDescription.text = movieData.plot
        self.labelMovieTitle.text = movieData.title
        self.labelMovieReleaseYear.text = "Released on : \n\(movieData.year ?? "")"
        
        let imageURL = URL(string: movieData.poster ?? "")
        self.imageViewMoviePoster.kf.setImage(with: imageURL, placeholder: UIImage(named: "no_movie_poster"), options: [.transition(.fade(0.5))])
        
        if movieData.isFavorite {
            self.buttonFavorite.setImage(UIImage(named: "fav_icon"), for: .normal)
        } else {
            self.buttonFavorite.setImage(UIImage(named: "non_fav_icon"), for: .normal)
        }
    }
    
}
