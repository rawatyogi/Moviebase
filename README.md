//
//  README.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 13/05/25.
//


#Moviebase-Task(MTSL)

 ##Overview
 The Moviebase app allow users to search movies by title and perform critical operations like adding movie to favorite, removing movie from favorite , displaying favorite movie in a list and navigating to detail screen for a particular movie tapped.
 
##Development Plan:
- App name: Moviebase-Task(MTSL)
- Minimum deployment target : iOS 15.6
- Category : Entertainment

##Tech Stack -
- Development : Swift + UIKit
- Persistenance : CoreData
- Network Layer : URLSession
- Architecture : MVVM
 - Design patterns: Singleton, Factory, Repository

#Features of Moviebase:
 ##Movies Flow:
 - This section hold users to search for a movie , view it , can favorite and unfavorite it and also can see its details in the movie detail screen.In the detail screen user can still make the movie favorite or if it is already favorite user can remove it from favorite.This section also mock to watch the movie.
 
 ##Favorite Flow -
 - User can see his favorite listed movies here user also can view the details of the movie.User is also able remove the movie from his favorite list.
 
 ##Settings Flow -
 - This is temporary flow which is not implemeneted. Purpose of the tab is to ensure better UI and U## Core Components:X.
 
#Core Components
 ##Network Layer :
 - Network layer is abstracted with protocol and URLSession is used with modern concurrency where response is propogated with Result<DataModel, Error> type.
 
 ##CoreData Layer :
 - Core Data layer is separated and uses repository pattern to manage CRUD on movie operations.
 
 ##UnitTests:
 - Unit test are integrated which provide testable environment for searching movie, making movie favorite and unfavorite and fetching movies.
 - Network layer and data repository is mocked and cases are included for business logic.
 
 ##ResponsiveUI:
 - Storyboards Canvas is used to design the responsive UI components with a salient UX.
 
 ## Third Party SDKs :
 - Kingfisher library is used for image caching via Swift Package Manager(SPM).
 
#Installation and Setup:
 ##Prerequisites:
 - XCode
 - macOS
 - Simulator Environment(iOS 15.6 +)

 ##Clone the Repository:
 - 
 
 ##Run the app:
 - Open the project in Xcode.
 - Select a simulator or connected device.
 - Press Cmd + R to build and run the app.
 

# Contact
- For any query feedback please connect on yogendrarawat0498@gmail.com

# License
- Not generated as this a task project
