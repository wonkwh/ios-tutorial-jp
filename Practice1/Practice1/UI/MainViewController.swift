import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            registerCells()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                let spacing: CGFloat = 8
                let size: CGFloat = (self.view.bounds.width - spacing) / 2

                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(size))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(spacing)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                return section
            }
            return layout
        }()
    }
}

extension MainViewController {
    private func registerCells() {
        collectionView.register(UINib(nibName: "IllustCell", bundle: nil),  forCellWithReuseIdentifier: "IllustCell")
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IllustCell", for: indexPath) as? IllustCell else {
            fatalError()
        }
        return cell
    }
}
