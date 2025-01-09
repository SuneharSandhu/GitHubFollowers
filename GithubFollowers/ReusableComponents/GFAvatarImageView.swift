import UIKit

class GFAvatarImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = .avatarPlaceholder
        translatesAutoresizingMaskIntoConstraints = false
    }
}
