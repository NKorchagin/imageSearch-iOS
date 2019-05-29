import UIKit

class ImageDetailAuthor: UITableViewCell {

    // MARK: - Properties

    let authorLabel = UILabel()

    // MARK: - Initialization and Deinitialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textAlignment = .right
        authorLabel.textColor = .gray

        let leading = NSLayoutConstraint(item: authorLabel,
                                         attribute: .leadingMargin,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leadingMargin,
                                         multiplier: 1,
                                         constant: 0)
        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailingMargin,
                                          relatedBy: .equal,
                                          toItem: authorLabel,
                                          attribute: .trailingMargin,
                                          multiplier: 1,
                                          constant: 0)
        let top = NSLayoutConstraint(item: authorLabel,
                                     attribute: .topMargin,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .topMargin,
                                     multiplier: 1,
                                     constant: 0)
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottomMargin,
                                        relatedBy: .equal,
                                        toItem: authorLabel,
                                        attribute: .bottomMargin,
                                        multiplier: 1,
                                        constant: 0)

        addConstraints([leading, trailing, top, bottom])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
