import Foundation

class ImageSearchService {

    // MARK: - Typealiases

    private typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

    // MARK: - Properties

    private var tasks: [URLSessionTask] = []
    private let session = URLSession(configuration: .default)

}

// MARK: - ImageSearchServiceType

extension ImageSearchService: ImageSearchServiceType {

    func searchImages(for request: String,
                      with providers: [ImageSearchProviderType],
                      completion: @escaping (SearchImagesResult) -> Void) {

        tasks.forEach { $0.cancel() }

        let dispatchGroup = DispatchGroup()
        var remoteImages: [RemoteImage] = []

        for provider in providers {
            guard let url = provider.url(with: request) else {
                assertionFailure("Could not create url for request")
                continue
            }

            dispatchGroup.enter()

            let dataTaskCompletion: DataTaskCompletion = { data, response, taskError in
                #if DEBUG
                if let requestURL = response?.url?.absoluteString {
                    print("Request url:", requestURL)
                }
                #endif

                if let taskError = taskError, !taskError.isCancellationError {
                    assertionFailure(taskError.localizedDescription)
                    dispatchGroup.leave()
                    return
                }

                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }

                if response?.isValid == false {
                    assertionFailure("Invalid response")
                    dispatchGroup.leave()
                    return
                }

                do {
                    let decodedData = try provider.decode(responseData: data)
                    remoteImages += decodedData
                    dispatchGroup.leave()
                } catch {
                    assertionFailure(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }

            let dataTask = self.session.dataTask(with: url, completionHandler: dataTaskCompletion)
            self.tasks.append(dataTask)
            dataTask.resume()

            let dispatchWait = dispatchGroup.wait(timeout: .now() + 10)
            switch dispatchWait {
            case .success:
                completion(.success(remoteImages))
            case .timedOut:
                completion(.failure(ServiceError.timedOut))
            }
        }
    }

}

// MARK: -

extension ImageSearchService {

    enum ServiceError: Error {
        case timedOut
    }

}

// MARK: -

private extension URLResponse {

    var isValid: Bool {
        guard let response = self as? HTTPURLResponse else { return true }
        switch response.statusCode {
        case 200 ... 300:
            return true
        default:
            return false
        }
    }

}

private extension Error {

    var isCancellationError: Bool {
        let nsError = self as NSError
        return nsError.code == -999 && nsError.localizedDescription == "cancelled"
    }

}
