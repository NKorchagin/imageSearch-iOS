import UIKit

extension UITableView {

    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError()
        }
        return cell
    }

    func register<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        register(Cell.self, forCellReuseIdentifier: identifier)
    }

}
