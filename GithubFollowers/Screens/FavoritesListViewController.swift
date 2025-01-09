import UIKit

class FavoritesListViewController: UIViewController {
    
    var favorites = [Follower]()
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(favoritesTableView)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    private func getFavorites() {
        Task {
            do {
                let favorites = try await DataManager.retrieveFavorites()
                if favorites.isEmpty {
                    showEmptyStateView(with: "You currently have no favorites", in: self.view)
                } else {
                    self.favorites = favorites
                    favoritesTableView.reloadData()
                    view.bringSubviewToFront(favoritesTableView)
                }
            } catch let error as PersistenceError {
                presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonText: "Ok")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTableView.frame = view.bounds
    }
}

extension FavoritesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListViewController(username: favorite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        favoritesTableView.deleteRows(at: [indexPath], with: .left)
        
        Task {
            do {
                try await DataManager.update(with: favorite, actionType: .remove)
            } catch let error as PersistenceError {
                presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonText: "Ok")
            }
        }
    }
}

extension FavoritesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        cell.configure(with: favorite)
        return cell
    }
}

