import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(title: "Get Followers", backgroundColor: .systemGreen)
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(for: user)
    }
}
