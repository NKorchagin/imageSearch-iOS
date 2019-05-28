import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    // MARK: - Properties

    var window: UIWindow?

}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Window.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()

        let mainViewContoller = MainViewContoller()
        let mainNavigationController = UINavigationController(rootViewController: mainViewContoller)
        mainNavigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = mainNavigationController



        return true
    }

}
