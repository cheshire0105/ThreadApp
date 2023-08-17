import UIKit

protocol ProfilePageModalDelegate: AnyObject {
    func profileUpdated(name: String, introduction: String, imageData: Data?)
    
}

class ProfilePageModalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageEdit: UIButton!
    @IBOutlet weak var profileEditSave: UIButton!
    
    
    
    
    
    
    
    
    weak var delegate: ProfilePageModalDelegate?
    var selectedImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 힌트 설정
        nameTextField.placeholder = "사용할 이름을 입력하세요(영어)" // "Enter your name" in English
        introductionTextField.placeholder = "간단한 자기소개를 작성하세요(영어)" // "Write your introduction" in English
        profileImageView.layer.cornerRadius = 30
        
        loadProfile()
        
    }
    
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImageData = image.jpegData(compressionQuality: 0.8)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: UIButton) {
        if let name = nameTextField.text, let introduction = introductionTextField.text {
            let profile = Profile(photoData: selectedImageData, name: name, bio: introduction)
            
            // 프로필 정보를 저장합니다.
            saveProfile(profile: profile)
            
            // delegate를 통해 프로필 정보를 전달합니다.
            delegate?.profileUpdated(name: name, introduction: introduction, imageData: selectedImageData)
            
            // 이 화면을 닫습니다.
            dismiss(animated: true, completion: nil)
        }
    }
    
    func saveProfile(profile: Profile) {
        do {
            let jsonData = try JSONEncoder().encode(profile)
            
            // UserDefaults에 저장
            UserDefaults.standard.set(jsonData, forKey: "profile")
            
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    func loadProfile() {
        do {
            if let savedProfile = UserDefaults.standard.object(forKey: "profile") as? Data {
                let profile = try JSONDecoder().decode(Profile.self, from: savedProfile)
                
                // 로드된 프로필 정보를 UI에 설정합니다.
                nameTextField.text = profile.name
                introductionTextField.text = profile.bio
                if let imageData = profile.photoData {
                    profileImageView.image = UIImage(data: imageData)
                }
            }
        } catch {
            print("Failed to load profile: \(error)")
        }
    }
    
    
    
    
}



