import UIKit

class ImageLoadingService {

    // MARK: - Properties

    private let fileManager = FileManager.default
    private let session = URLSession(configuration: .default)
    private let tempDirectory = NSTemporaryDirectory()

}

// MARK: - Private

private extension ImageLoadingService {

    func cachedImage(name: String) -> UIImage? {
        let path = tempDirectory + "/" + name
        return UIImage(contentsOfFile: path)
    }

    func cache(imageData: Data, for name: String) {
        let path = tempDirectory + "/" + name

        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
        }

        fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
    }

}

// MARK: - ImageLoadingServiceType

extension ImageLoadingService: ImageLoadingServiceType {

    func loadImage(from url: URL, completion: @escaping (URL, UIImage?) -> Void) {
        let name = url.absoluteString
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "www.", with: "")
            .replacingOccurrences(of: "/", with: "_")

        if let cachedImage = cachedImage(name: name) {
            #if DEBUG
            print("Image was taken from cache")
            #endif

            completion(url, cachedImage)
            return
        }

        let dataTaskCompletion: DataTaskCompletion = { [weak self] data, response, taskError in
            guard let `self` = self else { return }

            #if DEBUG
            if let requestURL = response?.url?.absoluteString {
                print("Request url:", requestURL)
            }
            #endif

            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }

            self.cache(imageData: data, for: name)
            completion(url, image)
        }
        session.dataTask(with: url, completionHandler: dataTaskCompletion)
            .resume()
    }

}
