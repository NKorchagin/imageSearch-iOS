import UIKit

class MainViewContoller: UICollectionViewController {

    // MARK: - Properties

    private let imageSearchService: ImageSearchServiceType
    private let imageLoadingService: ImageLoadingServiceType

    private let searchController = UISearchController(searchResultsController: nil)

    private var images: [RemoteImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Initialization and Deinitialization

    init(imageSearchService: ImageSearchServiceType, imageLoadingService: ImageLoadingServiceType) {
        self.imageSearchService = imageSearchService
        self.imageLoadingService = imageLoadingService

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.minimumLineSpacing = 16
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 16,
                                                         left: 16,
                                                         bottom: 16,
                                                         right: 16)

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
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Search"

        definesPresentationContext = true
    }

    func configureCollectionView() {
        collectionView.register(cellClass: MainViewImageCell.self)
    }

    func searchImages(for text: String) {
        collectionView.backgroundView = UIActivityIndicatorView(style: .whiteLarge)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.imageSearchService.searchImages(for: text, with: [ImageSearchProvider.googleImages]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let images):
                        self.collectionView.backgroundView = nil
                        self.images += images
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
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
        imageLoadingService.loadImage(from: images[indexPath.row].url) { [weak cell, weak self] (url, image) in
            guard let `self` = self else { return }
            guard let cell = cell else { return }
            guard url.absoluteString == self.images[indexPath.row].url.absoluteString else { return }
            cell.imageView.setImage(for: image)
        }
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

// MARK: - UISearchBarDelegate

extension MainViewContoller: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        images = []
        guard !searchText.isEmpty else { return }
        searchImages(for: searchText)
    }

}
