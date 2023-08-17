import Foundation
import UIKit

class ProfilePage: UIViewController,ProfilePageModalDelegate,UITableViewDataSource,UITabBarDelegate, UITableViewDelegate {
    
    func refreshThreads() {
            self.loadThreads()  // 스레드 데이터를 새로 불러옵니다.
            self.ProfileDetailFeild.reloadData()  // 테이블 뷰를 새로고침합니다.
        }
    
    
    
    // IBOutlet 선언부
    @IBOutlet weak var MoreViewButton: UIButton!
    // ... 버튼
    @IBOutlet weak var BellButton: UIButton!
    //  벨 버튼
    @IBOutlet weak var InstaButton: UIButton!
    //  인스타 버튼
    @IBOutlet weak var ProfileImage: UIImageView!
    //  프로필 이미지
    @IBOutlet weak var ProfileName: UITextField!
    //  프로필 이름
    @IBOutlet weak var ProfileInfo: UITextField!
    //  프로필 정보
    @IBOutlet weak var ProfileThreadButton: UIButton!
    //  ThreadButton
    @IBOutlet weak var ProfileRepliesButton: UIButton!
    //  RepliesButton
    @IBOutlet weak var ProfileReportsButton: UIButton!
    //  ReportsButton
    //  ProfileMeunBar
    
    @IBOutlet weak var ProfileDetailFeild: UITableView!
    
    var threadTitles: [String] = []
    //목업 타이틀
    
    // Profile 데이터를 저장할 변수. 값이 설정되면 UI도 자동으로 업데이트
    var userProfile: Profile? {
        didSet {
            updateUIWithProfileData()
        }
    }
    
    var threads: [Thread] = []  // 스레드 목록을 저장할 배열
    
    
    // ViewDidLoad: 뷰가 메모리에 로드된 후 호출됨
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileDetailFeild.delegate = self
        ProfileDetailFeild.dataSource = self
        
        ProfileDetailFeild.register(UITableViewCell.self, forCellReuseIdentifier: "threadTitleCell")
        
        // 프로필 이미지를 원형으로 설정
        ProfileImage.layer.cornerRadius = 30
        
        loadProfile()
        
        // 초기에 ProfileThreadButtonTapped 버튼이 눌러진 것처럼 설정
        ProfileThreadButton.tintColor = .black
        ProfileRepliesButton.tintColor = .gray
        ProfileReportsButton.tintColor = .gray
        
        ProfileDetailFeild.register(UINib(nibName: "tableView", bundle: nil), forCellReuseIdentifier: "ThreadCell")
        
        loadThreads()  // 스레드 데이터 불러오기
        
        
    }
    
    // 첫 번째 버튼 액션
    @IBAction func ProfileThreadButtonTapped(_ sender: UIButton) {
        ProfileThreadButton.tintColor = .black
        ProfileRepliesButton.tintColor = .gray
        ProfileReportsButton.tintColor = .gray
    }
    
    // 두 번째 버튼 액션
    @IBAction func ProfileRepliesButtonTapped(_ sender: UIButton) {
        // 진행률을 현재 값에서 66%로 애니메이션하여 변경
        ProfileThreadButton.tintColor = .gray
        ProfileRepliesButton.tintColor = .black
        ProfileReportsButton.tintColor = .gray
    }
    
    // 세 번째 버튼 액션
    @IBAction func ProfileReportsButtonTapped(_ sender: UIButton) {
        // 진행률을 현재 값에서 100%로 애니메이션하여 변경
        // 각 버튼의 색상을 업데이트
        ProfileThreadButton.tintColor = .gray
        ProfileRepliesButton.tintColor = .gray
        ProfileReportsButton.tintColor = .black
    }
    
    @IBAction func MoreViewAction(_ sender: UIButton) {
        // Instantiate the ProfilePageModalViewController
        let storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        if let profileModalVC = storyboard.instantiateViewController(withIdentifier: "ProfilePageModalViewController") as? ProfilePageModalViewController {
            
            // Set the delegate
            profileModalVC.delegate = self
            
            // Present the ProfilePageModalViewController
            self.present(profileModalVC, animated: true, completion: nil)
        }
        // 추가
    }
    
    
    
    
    
    
    
    //  프로필 수정
    func profileUpdated(name: String, introduction: String, imageData: Data?) {
        // 새로운 Profile 인스턴스를 생성하고, 이를 userProfile 변수에 할당합니다.
        userProfile = Profile(photoData: imageData, name: name, bio: introduction)
        
        // UI 업데이트
        updateUIWithProfileData()
    }
    func loadProfile() {
        do {
            if let savedProfile = UserDefaults.standard.object(forKey: "profile") as? Data {
                let profile = try JSONDecoder().decode(Profile.self, from: savedProfile)
                
                // 로드된 프로필 정보를 userProfile 변수에 설정합니다.
                userProfile = profile
            }
        } catch {
            print("Failed to load profile: \(error)")
        }
    }
    
    func updateUIWithProfileData() {
        guard let profile = userProfile else { return }
        
        DispatchQueue.main.async {
            // 이미지 설정
            if let data = profile.photoData {
                self.ProfileImage.image = UIImage(data: data)
            }
            
            // 이름 설정
            self.ProfileName.text = profile.name
            
            // 자기 소개 설정
            self.ProfileInfo.text = profile.bio
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! TableViewCell
        let thread = threads[indexPath.row]
        
        cell.celltitleLabel.text = thread.title
        cell.contentLabel.text = thread.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. 데이터 모델에서 삭제
            ThreadStore.shared.deleteThread(at: indexPath.row)
            
            // 2. 테이블 뷰에서 해당 셀을 삭제
            threads.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    func saveThreads() {
        do {
            let encoder = JSONEncoder()
            let encodedThreads = try encoder.encode(threads)
            UserDefaults.standard.set(encodedThreads, forKey: "savedThreads")
        } catch {
            print("Failed to encode threads: \(error)")
        }
    }


    
    
    func loadThreads() {
        
        guard let savedThreadsData = UserDefaults.standard.data(forKey: "savedThreads") else {
            print("No threads saved in UserDefaults.")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedThreads = try decoder.decode([Thread].self, from: savedThreadsData)
            self.threads = decodedThreads
            ProfileDetailFeild.reloadData()  // 테이블 뷰 갱신
            print(threads)

        } catch {
            print("Failed to decode saved threads: \(error)")
        }
        
    }
    
    @objc func reloadThreads() {
            // 스레드 데이터를 새로 불러오고, 테이블 뷰를 갱신합니다.
            loadThreads()
        }
        
        
    
    
    
}
