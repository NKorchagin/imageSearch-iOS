import UIKit

extension UIImageView {

    func addActivityIndicator() {
        if let indicator = subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
            indicator.startAnimating()
        } else {
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false

            let centerX = NSLayoutConstraint(item: indicator,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
            let centerY = NSLayoutConstraint(item: indicator,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)

            DispatchQueue.main.async {
                self.addSubview(indicator)
                self.addConstraints([centerX, centerY])
                indicator.startAnimating()
            }
        }
    }

    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.subviews
                .compactMap { $0 as? UIActivityIndicatorView }
                .forEach { $0.stopAnimating() }
        }
    }

    func setImage(for image: UIImage?) {
        DispatchQueue.main.async {
            self.image = image
        }
    }

}
