import Social
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
        configureShareButton()
    }

}

// MARK: - Private

private extension ImageDetailViewController {

    func configureTableView() {
        tableView.register(cellClass: ImageDetailCell.self)
        tableView.register(cellClass: ImageDetailAuthor.self)

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

    func configureShareButton() {
        let image = UIImage(named: "Share")
        let item = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(shareButtonTouchedUp(sender:)))
        navigationItem.rightBarButtonItem = item
    }

    @objc func shareButtonTouchedUp(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)

        /*There is no any sence to create closure in scope if you are not going to reuse it.
         It would be much cleaner code if you add this block as trailing param for
         UIAlertAction(...) { code } And no need of extra typealias
         */
        let facebookActionHandler: AlertActionHandler = { [weak self] _ in
            // You can use self without ` ` it's fixed in recent Swift versions
            guard let `self` = self else { return }
            self.imageLoadingService.loadImage(from: self.image.url, completion: { url, image in
                guard
                    let image = image,
                    let shareController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                else {
                    self.presentErrorAlert()
                    return
                }

                shareController.add(image)
                shareController.add(url)
                self.present(shareController, animated: true)
            })
        }

        let facebookAction = UIAlertAction(title: "Facebook", style: .default, handler: facebookActionHandler)
        alert.addAction(facebookAction)

        let moreActionHandler: AlertActionHandler = { [weak self] _ in
            guard let `self` = self else { return }
            self.imageLoadingService.loadImage(from: self.image.url, completion: { url, image in
                guard let image = image else {
                    self.presentErrorAlert()
                    return
                }

                let controller = UIActivityViewController(activityItems: [url, image], applicationActivities: nil)
                self.present(controller, animated: true)
            })
        }

        let moreAction = UIAlertAction(title: "More", style: .default, handler: moreActionHandler)
        alert.addAction(moreAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true)
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
                //I would rather add dispatch main thread here than inside 3 different remoteImageView methods
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

// MARK: -

extension UIViewController {

    func presentErrorAlert() {
        let alert = UIAlertController(title: "Ooops", message: "Something went wrong. Please, try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }

}
