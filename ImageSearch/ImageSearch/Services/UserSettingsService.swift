import Foundation

class UserSettingsService {

    // MARK: - Constants

    private let imageSearchProvidersKey = "imageSearchProviders"
}

// MARK: - UserSettingsServiceType

extension UserSettingsService: UserSettingsServiceType {

    var imageSearchProviders: [ImageSearchProviderType] {
        get {
            let defaultsProviders = UserDefaults.standard.array(forKey: imageSearchProvidersKey)?
                .compactMap { $0 as? String }
                .compactMap { ImageSearchProvider(rawValue: $0) }
            return defaultsProviders ?? ImageSearchProvider.allCases
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageSearchProvidersKey)
            NotificationCenter.default.post(name: .didUpdateImageSearchProviders, object: nil)
        }
    }

}

// MARK: -

extension Notification.Name {

    static let didUpdateImageSearchProviders = Notification.Name("didUpdateImageSearchProviders")
}
