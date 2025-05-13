//
//  MoviesDetailsVC.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 11/05/25.
//

import UIKit
import Kingfisher

class MoviesDetailsVC: UIViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewDismiss: UIView!
    @IBOutlet weak var labelRated: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewWatchNow: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelGenre1: UILabel!
    @IBOutlet weak var labelGenre2: UILabel!
    @IBOutlet weak var labelGenre3: UILabel!
    @IBOutlet weak var labelGenre4: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    @IBOutlet weak var labelWatchNow: UILabel!
    @IBOutlet weak var labelFavorite: UILabel!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var viewPosterHolder: UIView!
    @IBOutlet weak var viewMarkFavorite: UIView!
    @IBOutlet weak var labelYearRelease: UILabel!
    @IBOutlet weak var labelContentType: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
 
    //MARK: PROPERTIES
    var movieData: MoviesModel?
    var operationFavorite: ((String, FavoriteOperations) -> Void)?
    var moviesViewModel = MoviesViewModel(service: MoviesServices(), repository: CDMovieManager())
  
    //MARK: VIEW LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMoviesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: PROPERTIES
    func setupUI() {
        viewPosterHolder.backgroundColor = .white.withAlphaComponent(0.25)
        viewDismiss.makeRounded(radius: DeviceType.shared.iPhoneDevice ? 5.0 : 12.0)
        viewWatchNow.makeRounded(radius: DeviceType.shared.iPhoneDevice ? 5.0 : 12.0)
        viewMarkFavorite.makeRounded(radius: DeviceType.shared.iPhoneDevice ? 5.0 : 12.0)
        viewPosterHolder.makeRounded(radius: DeviceType.shared.iPhoneDevice ? 10.0 : 18.0)
        viewPosterHolder.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.7).cgColor
        viewPosterHolder.layer.borderWidth = 1.0
    }
    
    //MARK: SETUP MOVIE DATA
    func setupMoviesData() {
        
        labelRated.text = movieData?.runtime
        labelRuntime.text = movieData?.rated
        labelContentType.text = movieData?.type?.capitalized
        labelMovieDescription.text = movieData?.plot
        self.labelMovieTitle.text = movieData?.title
        self.labelYearRelease.text = "\(movieData?.year ?? "")"
        
        let imageURL = URL(string: movieData?.poster ?? "")
        self.imageViewMoviePoster.kf.setImage(with: imageURL, placeholder: UIImage(named: "no_movie_poster"), options: [.transition(.fade(0.5))])
        
        //If there are more than 4 genres we won't be able to see after 4 as this time this view is only for <= 4 genres.
        let genres = movieData?.genre?.components(separatedBy: ",").map{  $0.trimmingCharacters(in: .whitespaces)} ?? []
        
        let genreLabels = [labelGenre1, labelGenre2, labelGenre3, labelGenre4]
        for (index, label) in genreLabels.enumerated() {
            if index < genres.count {
                label?.isHidden = false
                label?.text = genres[index]
            } else {
                label?.isHidden = true
            }
        }
        
        if movieData?.isFavorite ?? false {
            self.labelFavorite.text = AppTexts.unfavorite.rawValue
            self.imageViewFavorite.image = UIImage(named: "fav_icon_detail")
        } else {
            self.labelFavorite.text = AppTexts.favorite.rawValue
            self.imageViewFavorite.image = UIImage(named: "unfav_icon_detail")
        }
    }
    
    //MARK: BACK BUTTON CLICKED
    @IBAction func buttonBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: FAVORITE BUTTON CLICKED
    @IBAction func buttonMarkFavoriteClicked(_ sender: UIButton) {
        //no need to carry extra id mapping opertions as it already contains isFavorite key
        if movieData?.isFavorite ?? false {
            movieData?.isFavorite = false
            let results = moviesViewModel.removeMovieFromFavorites(id: movieData?.imdbID ?? "")
            handleFavoriteMovieReponse(result: results, operation: .unfavorite )
            self.imageViewFavorite.image = UIImage(named: "unfav_icon_detail")
            self.labelFavorite.text = AppTexts.favorite.rawValue
        } else {
            guard var movie = movieData else { return }
            movie.isFavorite = true
            movieData?.isFavorite = true
            let results = moviesViewModel.addMovieToFavorites(movie: movie)
            handleFavoriteMovieReponse(result: results, operation: .markFavorite)
            self.imageViewFavorite.image = UIImage(named: "fav_icon_detail")
            self.labelFavorite.text = AppTexts.unfavorite.rawValue
        }
    }
    
    //MARK: DISMISS BUTTON CLICKED
    @IBAction func buttonDismissClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Corresponding function to handle action of fav and unfav
    func handleFavoriteMovieReponse(result: Result<String, CDErrors>, operation: FavoriteOperations) {
      
        switch result {
        case .success(let message):
            self.showAlert(title: AppTexts.favorite_your_movie.rawValue, message: message)
            operationFavorite?(movieData?.imdbID ?? "", operation)
            
        case .failure(let failure):
            handleCoreDataErrors(error: failure)
        }
    }
    
    //Handling Core Data erros
    func handleCoreDataErrors(error: CDErrors) {
        
        switch error {
      
        case .could_not_remove_favorite:
            self.showAlert(title: AppTexts.favorite_your_movie.rawValue, message: AppTexts.movie_not_removed_from_favorite.rawValue)
            
        case .could_not_mark_favorite:
            self.showAlert(title: AppTexts.favorite_your_movie.rawValue, message: AppTexts.movie_not_added_to_favorite.rawValue)
            
        default:
            break
        }
    }
}

