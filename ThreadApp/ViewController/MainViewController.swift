//
//  MainViewController.swift


import UIKit

final class MainViewController: UIViewController {
    
    private enum Section {
        case main
    }
    private var mockThreads: [Thread] = [.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보"))]
    
    
    @IBOutlet weak var threadsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Thread>!
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, Thread>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        threadsCollectionConfigure()
    }
    
    private func threadsCollectionConfigure() {
        
        threadsCollectionView.collectionViewLayout = createCompositionalLayout()
        threadsCollectionView.register(
            UINib(nibName: MainCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: MainCollectionViewCell.identifier
        )
        configureDataSource()
        // 샘플 데이터 저장
        applySnapshot(items: mockThreads)
        applySnapshotAppend(items: [.init(title: "테스트", createdAt: .init(), content: "키르키즈스탄", photoData: UIImage(systemName: "dogImage")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "dogImage")?.pngData(), name: "반가워", bio: "정보"))], section: .main)
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return compositionalLayout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Thread>(
            collectionView: threadsCollectionView
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewCell.identifier,
                for: indexPath
            ) as? MainCollectionViewCell else {return UICollectionViewCell()}
            cell.bind(thread: item)
            cell.threadStackViewTapped = { thread in
                // 스레드 클릭시
                //                dump(thread)
            }
            return cell
        }
    }
    
    private func applySnapshot(items: [Thread]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapshotAppend(items: [Thread], section: Section) {
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    func showProfilePage() {
        let profilePage = ProfilePage()
        navigationController?.pushViewController(profilePage, animated: true)
    }
}
    

