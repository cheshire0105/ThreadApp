import Foundation
import UIKit

class ProfilePage: UIViewController {
    
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
    @IBOutlet weak var ProfileMeunBar: UIProgressView!
    //  ProfileMeunBar
    @IBOutlet weak var ProfileDetailFeild: UITextField!
    //  ProfileDetailFeild
    
    
    // Profile 데이터를 저장할 변수. 값이 설정되면 UI도 자동으로 업데이트
    var userProfile: Profile? {
        didSet {
            updateUIWithProfileData()
        }
    }
    
    
    // ViewDidLoad: 뷰가 메모리에 로드된 후 호출됨
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 프로필 이미지를 원형으로 설정
        ProfileImage.layer.cornerRadius = 30
    }

    // 첫 번째 버튼 액션
    @IBAction func ProfileThreadButtonTapped(_ sender: UIButton) {
        // 진행률을 0%에서 33%로 애니메이션하여 변경
        animateProgress(from: ProfileMeunBar.progress, to: 0.33)
    }

    // 두 번째 버튼 액션
    @IBAction func ProfileRepliesButtonTapped(_ sender: UIButton) {
        // 진행률을 현재 값에서 66%로 애니메이션하여 변경
        animateProgress(from: ProfileMeunBar.progress, to: 0.66)
    }

    // 세 번째 버튼 액션
    @IBAction func ProfileReportsButtonTapped(_ sender: UIButton) {
        // 진행률을 현재 값에서 100%로 애니메이션하여 변경
        animateProgress(from: ProfileMeunBar.progress, to: 1.0)
    }

    @IBAction func MoreViewAction(_ sender: UIButton) {
    }
    

    
    
    // 진행률 애니메이션 함수
    func animateProgress(from start: Float, to end: Float) {
        let duration: TimeInterval = 0.5 // 애니메이션 지속 시간
        let animationStep: TimeInterval = 0.01 // 애니메이션 단계별 시간
        var currentProgress = start  // 시작 진행률
    
        // 진행률 증가 또는 감소량 계산
        let increment = (end - start) * Float(animationStep / duration)
    
        // Timer를 사용해 진행률을 점차적으로 변경
        Timer.scheduledTimer(withTimeInterval: animationStep, repeats: true) { timer in
            currentProgress += increment
            // 목표 진행률에 도달하면 타이머 종료
            if (increment > 0 && currentProgress >= end) || (increment < 0 && currentProgress <= end) {
                currentProgress = end
                timer.invalidate()
            }
        
            // UIProgressView 업데이트
            self.ProfileMeunBar.setProgress(currentProgress, animated: false)
        }
    }
    
    // 주어진 Profile 데이터를 사용하여 UI를 업데이트하는 함수
    func updateUIWithProfileData() {
        guard let profile = userProfile else { return }

        // 이미지 설정
        if let data = profile.photoData {
            ProfileImage.image = UIImage(data: data)
        }
        
        // 이름 설정
        ProfileName.text = profile.name
        
//        ProfileInfo.text = profile.introduction
    }
    
    //  프로필 수정
    func profileUpdated(name: String, introduction: String, imageData: Data?) {
        userProfile?.name = name
//        userProfile?.introduction = introduction
        if let data = imageData {
            userProfile?.photoData = data
            ProfileImage.image = UIImage(data: data)
        }
        updateUIWithProfileData()
    }
}
