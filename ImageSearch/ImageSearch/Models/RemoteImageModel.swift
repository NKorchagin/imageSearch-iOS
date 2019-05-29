import UIKit

struct RemoteImage {

    // MARK: - Properties

    let url: URL
    let author: String?
    let tags: [String]

    //Why variables?
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
        // Coulde be inside single guard statement, cause in both cases return is the same
        guard let imageWidth = imageWidth else { return nil }
        guard let imageHeight = imageHeight else { return nil }
        return CGSize(width: imageWidth, height: imageHeight)
    }

}
