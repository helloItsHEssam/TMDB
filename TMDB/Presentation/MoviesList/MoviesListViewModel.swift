//
//  MoviesListViewModel.swift
//  TMDB
//
//  Created by Radwa Ahmed on 01/09/2023.
//

import Foundation
import Combine

class MoviesListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let category: MovieCategory
    private let service: MoviesServiceProtocol
    private let router: MoviesListRouter
    
    @Published var movies: [Movie] = []
    @Published var errorMessage: String? = nil
    @Published var searchKeyword: String = ""
    
    var currentPage = 1 {
        didSet {
            guard self.currentPage <= self.noOfPages else { return }
            self.fetchMovies()
        }
    }
    var noOfPages = 1
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(
        category: MovieCategory,
        service: MoviesServiceProtocol = MoviesService.default,
        router: MoviesListRouter
    ) {
        self.category = category
        self.service = service
        self.router = router
        
        self.fetchMovies()
        self.search()
    }
    
}

// MARK: - ViewModelInput

extension MoviesListViewModel: MoviesListViewModelInputProtocol {
    
    func fetchMovies() {
        switch category {
        case .popular:
            self.storeMovies(
                self.service.getPopular(self.currentPage)
            )
            
        case .nowPlaying:
            self.storeMovies(
                self.service.getNowPlaying(self.currentPage)
            )
            
        case .upcoming:
            self.storeMovies(
                self.service.getUpcoming(self.currentPage)
            )
            
        case .topRated:
            self.storeMovies(
                self.service.getTopRated(self.currentPage)
            )
        }
    }
    
    func search() {
        self.storeMovies(
            self.service.search(
                self.searchKeyword,
                page: self.currentPage
            )
        )
    }
    
    func storeMovies(_ publisher: MoviesPublisher<MoviesDTO>) {
        publisher
            .sink { [weak self] completion in
            switch completion {
            case .finished: ()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] result in
            if self?.currentPage == 1 {
                self?.movies.removeAll()
            }
            let moviesForCurrentPage = result.movies.map { Movie(dto: $0) }
            self?.movies.append(contentsOf: moviesForCurrentPage)
            self?.noOfPages = result.noOfPages
        }
        .store(in: &cancellables)
    }
    
    func didTapOnMovie(_ id: Int) {
        self.router.showMovieDetails(id)
    }
    
}
