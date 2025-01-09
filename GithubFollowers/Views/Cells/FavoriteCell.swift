import UIKit

class FavoriteCell: UITableViewCell {

    static let identifier = "FavoriteCell"
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let usernameLabel = GFTitleLabel(font: .systemFont(ofSize: 26, weight: .semibold), textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        accessoryType = .disclosureIndicator
        applyConstraints()
    }
    
    private func applyConstraints() {
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with favorite: Follower) {
        usernameLabel.text = favorite.login
        
        Task {
            let image = await NetworkManager.shared.downloadImage(from: favorite.avatarUrl)
            avatarImageView.image = image
        }
    }
}
