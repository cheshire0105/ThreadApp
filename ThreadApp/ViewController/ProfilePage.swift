import Foundation
import UIKit

class ProfilePage: UIViewController,ProfilePageModalDelegate,UITableViewDataSource,UITabBarDelegate, UITableViewDelegate {
    
    
    
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
        return ThreadTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadTitleCell", for: indexPath)
        cell.textLabel?.text = ThreadTitle[indexPath.row]
        return cell
    }
    
    
    
}
let ThreadTitle : [String] = [
    "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇweaㅁㅇ",
    "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea",
    "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea",
    "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea"
]

