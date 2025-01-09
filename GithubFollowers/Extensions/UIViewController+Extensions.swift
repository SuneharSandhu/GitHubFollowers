import SafariServices
import UIKit

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonText: String) {
        DispatchQueue.main.async {
            let vc = GFAlertViewController(alertTitle: title, alertMessage: message, buttonText: buttonText)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
