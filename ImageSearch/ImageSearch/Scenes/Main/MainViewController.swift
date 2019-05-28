import UIKit

class MainViewContoller: UICollectionViewController {

    // MARK: - Properties

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Initialization and Deinitialization

    init() {
        let collectionViewLayout = UICollectionViewFlowLayout()

        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Base Class

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureSearchBar()
    }

}

// MARK: - Private

private extension MainViewContoller {

    func configureSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
    }

}
