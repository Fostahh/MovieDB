
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
    @IBOutlet weak var genreErrorView: UIView!
    @IBOutlet weak var genreRefreshButton: UIButton!
    @IBOutlet weak var movieErrorView: UIView!
    @IBOutlet weak var movieRefreshButton: UIButton!

    private lazy var loadingFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: movieTableView.bounds.width, height: 56))
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.center = CGPoint(x: footer.bounds.midX, y: footer.bounds.midY)
        spinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        footer.addSubview(spinner)
        return footer
    }()

    private lazy var emptyMovieView: UILabel = {
        let label = UILabel()
        label.text = Constant.noMovies
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    @IBAction func onGenreRefreshTapped(_ sender: UIButton) {
        presenter?.refreshGenre()
    }

    @IBAction func onMovieRefreshTapped(_ sender: UIButton) {
        presenter?.refreshMovie()
    }
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

// MARK: - UICollectionView Delegates
extension ListMovieView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfGenres ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }

        switch presenter.cellForItemAt(indexPath.item) {
        case .success(let genre):
            cell.configure(with: genre)
        case .loading:
            cell.showShimmer()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectGenre(at: indexPath.item)
    }
}

// MARK: - UITableView Delegates
extension ListMovieView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfMovies ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter, let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        switch presenter.cellForRowAt(indexPath.row) {
        case .loading:
            cell.showShimmer()
        case .success(let movie):
            cell.configureCell(movie: movie)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchMoreMoviesIfNeeded(currentRow: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectMovie(at: indexPath.row)
    }
}

// MARK: - Stub Presenter
extension ListMovieView: ListMoviePresenterToView {
    func reloadGenres() {
        guard (presenter?.numberOfGenres ?? 0) > 0 else { return }
        genreCollectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: []
        )
    }

    func renderGenreState(_ state: GenreUIState) {
        if case .error(let message) = state {
            genreCollectionView.isHidden = true
            genreErrorView.isHidden = false
            genreRefreshButton.isHidden = false
            Toast.showMessage(message, type: .error)
        } else {
            genreCollectionView.isHidden = false
            genreErrorView.isHidden = true
            genreRefreshButton.isHidden = true
            genreCollectionView.reloadData()
            reloadGenres()
        }
    }

    func renderMovieState(_ state: MovieUIState) {
        switch state {
        case .error(let message):
            movieTableView.isHidden = true
            movieErrorView.isHidden = false
            movieRefreshButton.isHidden = false
            Toast.showMessage(message, type: .error)
        case .empty:
            movieTableView.isHidden = false
            movieErrorView.isHidden = true
            movieRefreshButton.isHidden = true
            movieTableView.backgroundView = emptyMovieView
            movieTableView.reloadData()
        case .loading, .success:
            movieTableView.isHidden = false
            movieErrorView.isHidden = true
            movieRefreshButton.isHidden = true
            movieTableView.backgroundView = nil
            movieTableView.reloadData()
        }
    }

    func showNoMoreMovies() {
        Toast.showMessage("No more movies to load.", type: .informative)
    }

    func showError(_ message: String) {
        Toast.showMessage(message, type: .error)
    }

    func showLoadingFooter() {
        guard movieTableView.tableFooterView == nil else { return }
        movieTableView.tableFooterView = loadingFooterView
    }

    func hideLoadingFooter() {
        movieTableView.tableFooterView = nil
    }
}
