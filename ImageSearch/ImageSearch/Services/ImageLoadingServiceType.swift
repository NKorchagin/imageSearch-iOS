import UIKit

protocol ImageLoadingServiceType {

    func loadImage(from url: URL, completion: @escaping (URL, UIImage?) -> Void)

}
