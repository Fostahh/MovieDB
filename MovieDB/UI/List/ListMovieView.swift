
//  ListMovieView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit

final class ListMovieView: UIViewController {
    
    var presenter: ListMovieViewToPresenter?

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var genreCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenreCollectionView()
        setupTableView()
        presenter?.viewDidLoad()
    }

    private func setupGenreCollectionView() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
    }

    private func setupTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 160
        movieTableView.estimatedRowHeight = 0
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
}

extension ListMovieView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfGenres ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell,
              let genre = presenter?.getGenre(at: indexPath.item) else {
            return UICollectionViewCell()
        }

        cell.configure(with: genre)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectGenre(at: indexPath.item)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectMovie(at: indexPath.row)
    }
}

extension ListMovieView: ListMoviePresenterToView {
    func reloadMovies() {
        movieTableView.reloadData()
    }

    func reloadGenres() {
        genreCollectionView.reloadData()
        guard (presenter?.numberOfGenres ?? 0) > 0 else { return }
        genreCollectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: []
        )
    }
}
