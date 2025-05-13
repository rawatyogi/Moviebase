//
//  MoviesVC.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit

/*
 This controller fetch a movie at a time while searching for a movie.To list the searched movie UITableView is used for scaling point of view.
 */
class MoviesVC: UIViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var textfieldSearch: UITextField!
    
    //MARK: PROPERTIES
    var searchWorkItem: DispatchWorkItem?
    var moviesViewModel = MoviesViewModel(service: MoviesServices(), repository: CDMovieManager())
    
    //MARK: VIEW LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.labelHeader.showView()
        self.viewSearchContainer.showView()
        showAndHideSearchButtons()
        self.navigationController?.navigationBar.isHidden = true
        
        //the placeholder animation was being stopped if we were switching the tabs
        if let placeholderView = (moviesTableView.backgroundView) as? SearchMoviesView {
            placeholderView.imageViewPlaceholder.pulsate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    //MARK: SETUP UI COMPONENTS
    func setupComponents() {
        setupTableView()
        setupTapGesture()
        setupTextFields()
        setupOtherUIComponents()
    }
    
    //MARK: SETUP TEXTFIELD
    func setupTextFields() {
        self.textfieldSearch.delegate = self
        self.textfieldSearch.textColor = .black
        self.textfieldSearch.backgroundColor = .white
        
        //Whenever text is changed it will trigger item for operation
        self.textfieldSearch.addTarget(self, action: #selector(textfieldEditing), for: .editingChanged)
    }
    
    //MARK: SETUP TABLE VIEW
    func setupTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.separatorStyle = .none
        
        updateTablePlaceholderState()
        moviesTableView.registerCell(identifier: MoviesTableCell.self)
    }
    
    //MARK: SETUP OTHER UI PART
    func setupOtherUIComponents() {
        self.buttonSearch.makeRounded(radius: 22.5)
        viewSearchContainer.makeRounded(radius: 12)
        viewSearchContainer.backgroundColor = .white
        self.view.backgroundColor = UIColor().colorWithHexString(hex: "#00002C")
    }
    
    //MARK: TAP ON SCREEN
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: BUTTON SEARCH CLICKED
    @IBAction func buttonSearchClicked(_ sender: UIButton) {
     //i have changed the UI so this action is not requried now
    }

    //MARK: BUTTON CLOSE SEARCH CLICKED
    @IBAction func buttonCloseSearchClicked(_ sender: UIButton) {
        textfieldSearch.text = nil
        self.buttonCross.isHidden = true
        self.buttonSearch.isHidden = false
        
        self.moviesViewModel.movies = []
        updateTablePlaceholderState()
        self.moviesTableView.reloadData()
    }
    
    //MARK: TEXTFIELD TRIGGER
    @objc func textfieldEditing(_ textField: UITextField) {
        
        //This is where previous dispatched request is cancelled and new one is processed
        searchWorkItem?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            guard let text = textField.text, !text.isEmpty else {
                self?.buttonSearch.isHidden = false
                self?.buttonCross.isHidden = true
                self?.moviesViewModel.movies = []
                self?.moviesTableView.reloadData()
                self?.updateTablePlaceholderState()
                return
            }
            self?.searchMovieByTitle(title: text)
            self?.showAndHideSearchButtons()
        }
        searchWorkItem = task
        /**
         This slight debounce help to optmise the frequent API calls. It prevents frequent requests based on user input
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
    
    //MARK: DISMISS KEYBOARD
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: HIDE SEARCH BUTTONS
    func showAndHideSearchButtons() {
        self.buttonSearch.isHidden = (textfieldSearch.text?.count ?? 0) > 0
        self.buttonCross.isHidden = !buttonSearch.isHidden
    }
    
    //MARK: SEARCH MOVIE BY TITLE
    func searchMovieByTitle(title: String) {
        
        //favorites are fetched first in order to map their IDs as in case that user searched movie.. favorite it, then research it so its favorite status will disappear so this mechanism is prepared.
        moviesViewModel.fetchFavoriteMovies()
        
        Task { [weak self] in
            AppLoader.shared.showLoader()
            self?.moviesTableView.resetPlaceholderView()
            let result = await self?.moviesViewModel.searchMovieByTitle(title: title)
            
            switch result {
            case .success:
                self?.updateTablePlaceholderState()
                
            case .failure(let error):
                
                switch error {
                    
                case .request_failed:
                    self?.moviesTableView.setPlaceholderView(message: AppTexts.offline_msg.rawValue, type: .requestFailed)
                    
                case .data_not_found:
                    self?.moviesTableView.setPlaceholderView(message: AppTexts.no_data_found.rawValue, type: .noDataFound)
                    
                case .something_went_wrong:
                    self?.moviesTableView.setPlaceholderView(message: AppTexts.try_again_msg.rawValue, type: .somethingUnexpected)
                }
            case .none:
                break
            }
            
            AppLoader.shared.stopLoader()
            self?.moviesTableView.reloadData()
        }
    }
    
    //MARK: TABLE PLACEHOLDER
    
    func updateTablePlaceholderState() {
        self.moviesViewModel.movies.count == 0 ?    (self.moviesTableView.setPlaceholderView(message: AppTexts.search_movie.rawValue, type: .noMovies)) : (self.moviesTableView.resetPlaceholderView())
    }
}

//MARK: TABLE VIEW DATASOURCE
/* All the table view data handling*/
extension MoviesVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableCell") as! MoviesTableCell
        
        let data = moviesViewModel.movies[indexPath.row]
        cell.setupMoviesDataOnCell(movieData: data)
        
        cell.buttonFavorite.tag = indexPath.row
        cell.buttonFavorite.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
}

//MARK: TABLE VIEW DELEGATE
/* All the table view interaction opeartions*/
extension MoviesVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.moviesViewModel.movies[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
        detailVC.movieData = movie
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.operationFavorite = { [weak self]  (id, operation) in
        
            switch operation {
            case .markFavorite:
                //Fetch the index in the viewed / operated movie and mark it favorite
                if let index = self?.moviesViewModel.movies.firstIndex(where: {$0.imdbID == id}) {
                    self?.moviesViewModel.movies[index].isFavorite = true
                }
            case .unfavorite:
                //Fetch the index in the viewed / operated movie and mark it unfavorite
                if let index = self?.moviesViewModel.movies.firstIndex(where: {$0.imdbID == id}) {
                    self?.moviesViewModel.movies[index].isFavorite = false
                }
            }
            self?.moviesTableView.reloadData()
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: TABLE CELL ACTIONS
extension MoviesVC {
 
    //Button on cell clicked to make movie fav or unfav
    @objc func favoriteButtonClicked(sender: UIButton) {
        
        var movie = self.moviesViewModel.movies[sender.tag]
        
        //Tapped movie's status is checked if it is favorite or not.Depending on the status local databse is updated and local view models data is toggled for UI.
        
        if movie.isFavorite {
            movie.isFavorite = false
            self.moviesViewModel.movies[sender.tag].isFavorite = false
            let results = moviesViewModel.removeMovieFromFavorites(id: movie.imdbID ?? "")
            handleFavoriteMovieReponse(result: results)
        } else {
            movie.isFavorite = true
            self.moviesViewModel.movies[sender.tag].isFavorite = true
            let results = moviesViewModel.addMovieToFavorites(movie: movie)
            handleFavoriteMovieReponse(result: results)
        }
    }
    
    //Corresponding function to handle action of fav and unfav
    func handleFavoriteMovieReponse(result: Result<String, CDErrors>) {
      
        switch result {
        case .success(let message):
            self.moviesTableView.reloadData()
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
            break
        }
    }
}

//MARK: TEXTFIELD DELEGATE DELEGATE
/* All the textfield interaction : hiding/showing corss button*/
extension MoviesVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldSearch.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showAndHideSearchButtons()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showAndHideSearchButtons()
    }
}


/*TO-DO
 
 1- User appeared on this tab, visible UI:
 - Header as distingushing movie screen
 - Search bar
 - A separator line
 - A placeholer suggesting to search for movies.
 
 #Functional Part :
 - User taps search bar: it become active
 - now entered keyword wither request can be sucess or failure and it will show loader
 - If request is sucess then table will reloaded with movie information.
 - If request is failed then corresponding placeholder or alert will displayed.
 - Upon success we can view full view of movie details and we can also add it to favorites.
 - Repective errors we can handle in terms or propogation for placeholders.
 */
