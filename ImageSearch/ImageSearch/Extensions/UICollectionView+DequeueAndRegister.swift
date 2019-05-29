import UIKit

extension UICollectionView {

    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue \(identifier) cell")
        }
        return cell
    }

    func register<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        register(Cell.self, forCellWithReuseIdentifier: identifier)
    }

}
