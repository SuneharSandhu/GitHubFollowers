import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repo, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(title: "GitHub Profile", backgroundColor: .systemPurple)
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGithubProfile(for: user)
    }
}
