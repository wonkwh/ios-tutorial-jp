import Combine
import Firebase
import FirebaseFirestoreSwift
import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            registerCells()
        }
    }

    private var sections: [Section] = [] {
        didSet {
            Task { @MainActor in
                self.collectionView.collectionViewLayout = {
                    let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                        return self.sections[sectionIndex].layoutSection()
                    }
                    return layout
                }()
                self.collectionView.reloadData()
            }
        }
    }

    private let viewModel = IllustViewModel(repository: IllustRepositoryImpl())
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$illusts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] illusts in
                guard let self = self else {
                    return
                }
                self.sections = [
                    RankingIllustSection(illusts: illusts, parentWidth: self.view.bounds.width),
                    IllustSection(illusts: illusts, parentWidth: self.view.bounds.width)
                ]
            }
            .store(in: &cancellables)

        Task {
            await viewModel.fetchIllusts()
        }
    }
}

extension MainViewController {
    private func registerCells() {
        collectionView.register(UINib(nibName: "HeaderCell", bundle: nil), forSupplementaryViewOfKind: "RecommendedHeader", withReuseIdentifier: "HeaderCell")
        collectionView.register(UINib(nibName: "HeaderCell", bundle: nil), forSupplementaryViewOfKind: "RankingHeader", withReuseIdentifier: "HeaderCell")
        collectionView.register(UINib(nibName: "IllustCell", bundle: nil),  forCellWithReuseIdentifier: "IllustCell")
        collectionView.register(UINib(nibName: "RankingIllustCell", bundle: nil),  forCellWithReuseIdentifier: "RankingIllustCell")
    }
}

extension MainViewController: UICollectionViewDelegate {
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
            return UICollectionReusableView()
        }
        switch kind {
        case "RecommendedHeader":
            header.bind("Recommended")
            return header
        case "RankingHeader":
            header.bind("Ranking")
            return header
        default:
             return UICollectionReusableView()
         }
    }
}
