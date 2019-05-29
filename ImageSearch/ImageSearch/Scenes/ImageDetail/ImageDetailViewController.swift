import UIKit

class ImageDetailViewController: UITableViewController {

    // MARK: - Properties

    private let image: RemoteImage
    private let imageLoadingService: ImageLoadingServiceType

    // MARK: - Initialization and Deinitialization

    init(image: RemoteImage, imageLoadingService: ImageLoadingServiceType) {
        self.image = image
        self.imageLoadingService = imageLoadingService

        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Base Class

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureTableView()
    }

}

// MARK: - Private

private extension ImageDetailViewController {

    func configureTableView() {
        tableView.register(cellClass: ImageDetailCell.self)
        tableView.register(cellClass: ImageDetailAuthor.self)

        tableView.tableFooterView = UIView()
    }

}

// MARK: - UITableViewDataSource

extension ImageDetailViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionIndex(rawValue: section) else { return 0 }
        switch section {
        case .author:
            return image.author == nil ? 0 : 1
        case .image:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionIndex(rawValue: indexPath.section) else {
            assertionFailure()
            return UITableViewCell()
        }

        switch section {
        case .image:
            let cell: ImageDetailCell = tableView.dequeueReusableCell(for: indexPath)
            cell.remoteImageView.addActivityIndicator()
            imageLoadingService.loadImage(from: image.url) { [weak cell, weak self] url, image in
                guard let `self` = self else { return }
                guard let cell = cell else { return }
                cell.remoteImageView.removeActivityIndicator()
                guard url.absoluteString == self.image.url.absoluteString else { return }
                cell.remoteImageView.setImage(for: image)
            }
            return cell
        case .author:
            let cell: ImageDetailAuthor = tableView.dequeueReusableCell(for: indexPath)
            guard let author = image.author else { return cell }
            cell.authorLabel.text = "Author: \(author)"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionIndex(rawValue: indexPath.section) else {
            assertionFailure()
            return 0
        }

        switch section {
        case .author:
            return UITableView.automaticDimension
        case .image:
            let width = tableView.bounds.width
            guard let imageSize = image.imageSize else { return width }
            return width / imageSize.width * imageSize.height
        }
    }

}

// MARK: - ImageDetailViewController

private extension ImageDetailViewController {

    enum SectionIndex: Int {
        case image
        case author
    }

}
