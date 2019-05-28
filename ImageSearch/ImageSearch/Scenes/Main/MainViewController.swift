import UIKit

class MainViewContoller: UICollectionViewController {

    // MARK: - Properties

    private let searchController = UISearchController(searchResultsController: nil)

    private var images: [RemoteImage] = [RemoteImage(url: nil, image: nil, author: nil, tags: [])] {
        didSet {
            collectionView.reloadData()
        }
    }

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

        collectionView.backgroundColor = .white

        configureSearchBar()
        configureCollectionView()
    }

}

// MARK: - Private

private extension MainViewContoller {

    func configureSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Search"
    }

    func configureCollectionView() {
        collectionView.register(cellClass: MainViewImageCell.self)
    }

}

// MARK: - UICollectionViewDataSource

extension MainViewContoller {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainViewImageCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewContoller: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 50, height: 50)
    }

}
