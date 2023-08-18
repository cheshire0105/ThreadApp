//
//  MainViewController.swift


import UIKit

final class MainViewController: UIViewController {
    
    // 스레드 목록을 저장할 프로퍼티
    private var threads: [Thread] = []
    
    
    
    
    
    // 스레드 데이터를 새로고침하는 함수
    func refreshThreads() {
        self.threadsCollectionView.reloadData()  // Collection View를 새로고침합니다.
    }
    
    private enum Section {
        case main
    }
    
    
    @IBOutlet weak var threadsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Thread>!
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, Thread>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThreadStore.shared.loadThreads() // 이 부분이 중요합니다.
        
        configure()
        
        // ThreadStore의 threads 배열에서 초기 데이터를 가져옴
        let initialThreads = ThreadStore.shared.threads
        applySnapshot(items: initialThreads)
        
        // 새로운 스레드가 추가되었을 때의 알림을 받도록 Observer를 추가
        NotificationCenter.default.addObserver(self, selector: #selector(reloadThreads), name: Notification.Name("NewThreadAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadThreads), name: Notification.Name("ThreadDataChanged"), object: nil)

        
        
    }
    
    @objc  func reloadThreads() {
        // ThreadStore의 threads 배열에서 새로운 데이터를 가져옴
        let newThreads = ThreadStore.shared.threads
        
        // 가져온 데이터를 사용하여 CollectionView를 업데이트
        applySnapshot(items: newThreads)
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
    
}

