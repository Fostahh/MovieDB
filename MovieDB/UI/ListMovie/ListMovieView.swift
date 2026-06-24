
//  ListMovieView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit

final class ListMovieView: UIViewController {
    
    var presenter: ListMovieViewToPresenter?

    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 160
        movieTableView.estimatedRowHeight = 0
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
}

extension ListMovieView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfMovies ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell,
              let movie = presenter?.getMovie(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configureCell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.loadMoreIfNeeded(currentRow: indexPath.row)
    }
}

extension ListMovieView: ListMoviePresenterToView {
    func reloadData() {
        movieTableView.reloadData()
    }
}
