import UIKit

class ImageDetailCell: UITableViewCell {

    // MARK: - Properties

    let remoteImageView = UIImageView()

    // MARK: - Initialization and Deinitialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(remoteImageView)
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        remoteImageView.contentMode = .scaleAspectFit

        let leading = NSLayoutConstraint(item: remoteImageView,
                                         attribute: .leadingMargin,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leadingMargin,
                                         multiplier: 1,
                                         constant: 0)
        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailingMargin,
                                          relatedBy: .equal,
                                          toItem: remoteImageView,
                                          attribute: .trailingMargin,
                                          multiplier: 1,
                                          constant: 0)
        let top = NSLayoutConstraint(item: remoteImageView,
                                     attribute: .topMargin,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .topMargin,
                                     multiplier: 1,
                                     constant: 0)
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottomMargin,
                                        relatedBy: .equal,
                                        toItem: remoteImageView,
                                        attribute: .bottomMargin,
                                        multiplier: 1,
                                        constant: 0)

        addConstraints([leading, trailing, top, bottom])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
