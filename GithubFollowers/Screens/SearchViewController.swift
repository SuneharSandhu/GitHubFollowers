import UIKit

class SearchViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ghLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let getFollowersButton = GFButton(title: "Get Followers", backgroundColor: .systemGreen)
    private let usernameTextField = GFTextField()
    
    var isUsernameNotEmpty: Bool {
        !usernameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = ""
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowerListVC() {
        guard isUsernameNotEmpty else {
            presentGFAlert(title: "Empty username", message: "Please enter a username.", buttonText: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let vc = FollowerListViewController(username: usernameTextField.text!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureUI() {
        view.addSubview(imageView)
        view.addSubview(usernameTextField)
        view.addSubview(getFollowersButton)
        
        usernameTextField.delegate = self
        getFollowersButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let usernameTextFieldConstraints = [
            usernameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            usernameTextField.heightAnchor.constraint(equalToConstant: Constants.height)
        ]
        
        let getFollowersButtonConstraints = [
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            getFollowersButton.heightAnchor.constraint(equalToConstant: Constants.height)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(getFollowersButtonConstraints)
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
    }
}

private struct Constants {
    static let padding: CGFloat = 50
    static let height: CGFloat = 50
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return textField.resignFirstResponder()
    }
}
