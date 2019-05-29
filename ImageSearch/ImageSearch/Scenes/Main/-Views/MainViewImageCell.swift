import UIKit

class MainViewImageCell: UICollectionViewCell {

    // MARK: - Properties

    let imageView = UIImageView()

    // MARK: - Initialization and Deinitialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension MainViewImageCell {

    func configureImageView() {
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        let leadingConstraint = NSLayoutConstraint(item: imageView,
                                                   attribute: .leadingMargin,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leadingMargin,
                                                   multiplier: 1,
                                                   constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailingMargin,
                                                    relatedBy: .equal,
                                                    toItem: imageView,
                                                    attribute: .trailingMargin,
                                                    multiplier: 1,
                                                    constant: 0)
        let topConstraint = NSLayoutConstraint(item: imageView,
                                               attribute: .topMargin,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .topMargin,
                                               multiplier: 1,
                                               constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .bottomMargin,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .bottomMargin,
                                                  multiplier: 1,
                                                  constant: 0)

        addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }

}
