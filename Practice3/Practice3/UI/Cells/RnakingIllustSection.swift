import UIKit

struct RankingIllustSection: Section {
    let illusts: [Illust]
    let parentWidth: CGFloat

    var numberOfItems: Int {
        return illusts.count
    }

    func layoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        let size: CGFloat = 256
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .absolute(size))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 0)
        section.interGroupSpacing = spacing

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32)),
            elementKind: "RankingHeader",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingIllustCell", for: indexPath) as? RankingIllustCell else {
            return UICollectionViewCell()
        }
        cell.bind(illusts[indexPath.item])
        return cell
    }
}
