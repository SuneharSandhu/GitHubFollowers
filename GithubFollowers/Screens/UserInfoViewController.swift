import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {
    
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var containerViews = [UIView]()
    var username: String!
    
    weak var delegate: FollowerListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        getUserInfo()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo() {
        Task {
            let user = try await NetworkManager.shared.getUserInfo(for: username)
            addChildVCs(user: user)
            dateLabel.text = "GitHub since " + user.createdAt.convertToMonthYearFormat()
        }
    }
    
    private func addChildVCs(user: User) {
        let repoItemVC = GFRepoItemViewController(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: UserInfoHeaderViewController(user: user), to: headerView)
        self.add(childVC: repoItemVC, to: itemViewOne)
        self.add(childVC: followerItemVC, to: itemViewTwo)
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    private func configureUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        containerViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in containerViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(title: "Invalid URL", message: "The url attached to this user is invalid", buttonText: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlert(title: "No followers", message: "This user has no followers 😞", buttonText: "Ok")
            return
        }
        
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
