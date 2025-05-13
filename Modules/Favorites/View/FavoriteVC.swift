//
//  FavoriteVC.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit

class FavoriteVC: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var favoriteTableView: UITableView!
   
    //MARK: PROPERTIES
    var favoriteViewModel = FavoriteViewModel(movieRepoistory: CDMovieManager())
    
    //MARK: VIEW LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMovies()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: SETUP UI COMPONENTS
    func setupComponents() {
        setupTableView()
        setupOtherUIComponents()
    }
    
    //MARK: SETUP TABLE VIEW
    func setupTableView() {
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.separatorStyle = .none
        
        updateTablePlaceholderState()
        favoriteTableView.registerCell(identifier: MoviesTableCell.self)
    }
    
    //MARK: SETUP OTHER UI PART
    func setupOtherUIComponents() {
        self.view.backgroundColor = UIColor().colorWithHexString(hex: "#00002C")
    }
    
    //MARK: TABLE PLACEHOLDER
    func updateTablePlaceholderState() {
        self.favoriteViewModel.moviesModel.count == 0 ?    (self.favoriteTableView.setPlaceholderView(message: AppTexts.add_favorite_movie.rawValue, type: .noFavoriteMovideAdded)) : (self.favoriteTableView.resetPlaceholderView())
    }
    
    //MARK: TABLE PLACEHOLDER
    func fetchFavoriteMovies() {
    
        let results = favoriteViewModel.getFavoriteMovies()
        switch results {
        case .success(_):
            updateTablePlaceholderState()
            self.favoriteTableView.reloadData()
            
        case .failure(let failure):
            AppLogs.shared.debugLogs(failure)
        }
    }
}

//MARK: TABLE VIEW DATASOURCE
/* All the table view data handling*/
extension FavoriteVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteViewModel.moviesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableCell") as! MoviesTableCell
        
        let data = favoriteViewModel.moviesModel[indexPath.row]
        cell.setupMoviesDataOnCell(movieData: data)
        
        cell.buttonFavorite.tag = indexPath.row
        cell.buttonFavorite.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        
        return cell
    }
}

//MARK: TABLE VIEW DELEGATE
/* All the table view interaction opeartions*/
extension FavoriteVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.favoriteViewModel.moviesModel[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
        detailVC.movieData = movie
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: TABLE CELL ACTIONS
extension FavoriteVC {
 
    //Button on cell clicked to make movie fav or unfav
    /**Although to add to fav part never work as we are here to undo the favorite or remove from favorites**/
    @objc func favoriteButtonClicked(sender: UIButton) {
        
        let movie = self.favoriteViewModel.moviesModel[sender.tag]
        
        if movie.isFavorite {
            let results = favoriteViewModel.removeMovieFromFavorites(id: movie.imdbID ?? "")
            handleFavoriteMovieResponse(result: results)
        } else {
            let results = favoriteViewModel.addMovieToFavorites(movie: movie)
            handleFavoriteMovieResponse(result: results)
        }
        self.favoriteViewModel.moviesModel[sender.tag].isFavorite.toggle()
        self.fetchFavoriteMovies()
    }
    
    //Corresponding function to handle action of fav and unfav
    func handleFavoriteMovieResponse(result: Result<String, CDErrors>) {
      
        switch result {
        case .success(let message):
            self.favoriteTableView.reloadData()
            self.showAlert(title: AppTexts.favorite_your_movie.rawValue, message: message)
            
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
            self.showAlert(title: AppTexts.favorite_your_movie.rawValue, message: AppTexts.unknownError.rawValue)
        }
    }
}
//test
