import Foundation

enum ImageSearchProvider {

    case googleImages

}

// MARK: - Private

private extension ImageSearchProvider {

    var basePath: String {
        switch self {
        case .googleImages:
            return "https://www.googleapis.com/customsearch/v1"
        }
    }

    func queryParameters(with searchRequest: String) -> [String: String] {
        switch self {
        case .googleImages:
            return ["key": "AIzaSyAmfQhowwWXfiRImxMm-lg2Cs92fglvSxw",
                    "cx": "011201834755125476644:yhqmj-bqkvw",
                    "searchType": "image",
                    "num": "10",
                    "imgSize": "medium",
                    "fields": "items"]
        }
    }

}

// MARK: - ImageSearchProviderType

extension ImageSearchProvider: ImageSearchProviderType {

    func url(with searchRequest: String) -> URL? {
        guard var urlComponents = URLComponents(string: basePath) else { return nil }

        var parameters = queryParameters(with: searchRequest)
        parameters["q"] = searchRequest

        let query = parameters
            .reduce("", { $0 + $1.key + "=" + $1.value + "&" })
            .dropLast()
        urlComponents.query = String(query)

        return urlComponents.url
    }

    func decode(responseData: Data) throws -> [RemoteImage] {
        switch self {
        case .googleImages:
            return try JSONDecoder().decode(GoogleImagesResponse.self, from: responseData).remoteImages
        }
    }

}

// MARK: -

private protocol RemoteImageConvertableResponse {

    var remoteImages: [RemoteImage] { get }

}

// MARK: -

private struct GoogleImagesResponse: Decodable {

    let items: [Item]

}

extension GoogleImagesResponse {

    struct Item: Decodable {

        let link: String
        let displayLink: String?
        let image: Image?

    }

}

extension GoogleImagesResponse {

    struct Image: Decodable {

        let height: Int
        let width: Int

    }

}

extension GoogleImagesResponse: RemoteImageConvertableResponse {
    var remoteImages: [RemoteImage] {
        return items
            .compactMap {
                guard let url = URL(string: $0.link) else { return nil }
                return RemoteImage(url: url,
                                   author: $0.displayLink,
                                   imageWidth: $0.image?.width,
                                   imageHeight: $0.image?.height)
            }
    }


}
