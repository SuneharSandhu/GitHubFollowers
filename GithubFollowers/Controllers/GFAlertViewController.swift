import UIKit

class GFAlertViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let alertTitleLabel = GFTitleLabel(font: .systemFont(ofSize: 20, weight: .bold), textAlignment: .center)
    let alertBodyLabel = GFBodyLabel(textAlignment: .center)
    let alertButton = GFButton(title: "Ok", backgroundColor: .systemPink)
    
    var alertTitle: String?
    var alertMessage: String?
    var buttonText: String?
    
    let padding: CGFloat = 20
    
    init(alertTitle: String?, alertMessage: String?, buttonText: String?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.buttonText = buttonText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureUI()
    }
    
    private func configureUI() {
        view.isOpaque = false
        
        view.addSubview(containerView)
        view.addSubview(alertTitleLabel)
        view.addSubview(alertBodyLabel)
        view.addSubview(alertButton)
        
        alertTitleLabel.text = alertTitle ?? "Something went wrong"
        
        alertBodyLabel.text = alertMessage ?? "Unable to complete request"
        alertBodyLabel.numberOfLines = 4
        
        alertButton.setTitle(buttonText ?? "Ok", for: .normal)
        alertButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        let containerViewConstraints = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
        ]
        
        let alertTitleConstraints = [
            alertTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            alertTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertTitleLabel.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let alertBodyLabelConstraints = [
            alertBodyLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 8),
            alertBodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertBodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertBodyLabel.bottomAnchor.constraint(equalTo: alertButton.topAnchor, constant: -12),
        ]
        
        let alertButtonConstraints = [
            alertButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            alertButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(alertTitleConstraints)
        NSLayoutConstraint.activate(alertBodyLabelConstraints)
        NSLayoutConstraint.activate(alertButtonConstraints)
    }
    
    @objc private func dismissAlert() {
        dismiss(animated: true)
    }
}
