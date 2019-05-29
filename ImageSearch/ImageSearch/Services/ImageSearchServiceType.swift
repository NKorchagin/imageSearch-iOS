import Foundation

protocol ImageSearchServiceType {

    typealias SearchImagesResult = Result<[RemoteImage], Error>

    func searchImages(for request: String,
                      with providers: [ImageSearchProviderType],
                      completion: @escaping (SearchImagesResult) -> Void)

}

// MARK: -

protocol ImageSearchProviderType {

    func url(with searchRequest: String) -> URL?
    func decode(responseData: Data) throws -> [RemoteImage]

}
