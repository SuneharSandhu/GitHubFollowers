import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var page: Int = 1
    var username: String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UIHelper.createThreeColumnFlowLayout(in: view)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        return collectionView
    }()
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        view.addSubview(collectionView)
        collectionView.delegate = self
        configureSearchController()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    @objc private func addButtonTapped() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                try await DataManager.update(with: favorite, actionType: .add)
                presentGFAlert(title: "Success!", message: "You have successfully favorited \(user.login)", buttonText: "Ok")
            } catch let error as NetworkError {
                presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonText: "Ok")
            } catch let error as PersistenceError {
                presentGFAlert(title: "Oops!", message: error.rawValue, buttonText: "Ok")
            }
        }
    }
    
    private func getFollowers(username: String, page: Int) {
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                
                if followers.count < 100 { self.hasMoreFollowers = false }
                
                await MainActor.run {
                    self.followers.append(contentsOf: followers)
                    if self.followers.isEmpty {
                        let message = "This user doesn't have any followers yet. Go follow them 😊"
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                    self.updateData(on: self.followers)
                }
            } catch {
                presentGFAlert(title: "Uh oh", message: error.localizedDescription, buttonText: "Ok")
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension FollowerListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == followers.count - 1 {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        let userInfoVC = UserInfoViewController()
        userInfoVC.delegate = self
        userInfoVC.username = follower.login
        let navController = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension FollowerListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// MARK: - UISearchBarDelegate
extension FollowerListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

// MARK: - FollowerListViewControllerDelegate
extension FollowerListViewController: FollowerListViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        
        getFollowers(username: username, page: page)
    }
}
