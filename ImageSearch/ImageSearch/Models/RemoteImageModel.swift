import UIKit

struct RemoteImage {

    // MARK: - Properties

    let url: URL
    let author: String?
    let tags: [String]

    private var imageWidth: Int?
    private var imageHeight: Int?

    // MARK: - Initialization and Deinitialization

    init(url: URL, author: String?, imageWidth: Int?, imageHeight: Int?) {
        self.url = url
        self.author = author
        self.tags = []
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }

}

// MARK: - Public

extension RemoteImage {

    var imageSize: CGSize? {
        guard let imageWidth = imageWidth else { return nil }
        guard let imageHeight = imageHeight else { return nil }
        return CGSize(width: imageWidth, height: imageHeight)
    }

}
