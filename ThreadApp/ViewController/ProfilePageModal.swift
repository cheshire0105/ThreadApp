import UIKit

protocol ProfilePageModalDelegate: AnyObject {
    func profileUpdated(name: String, introduction: String, imageData: Data?)
    
}

class ProfilePageModalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageEdit: UIButton!
    @IBOutlet weak var profileEditSave: UIButton!
    
    
    
    
    
    
    
    weak var delegate: ProfilePageModalDelegate?
    var selectedImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        // 힌트 설정
        nameTextField.placeholder = "사용할 이름을 입력하세요(영어)" // "Enter your name" in English
        introductionTextField.delegate = self
        introductionTextField.text = "간단한 자기소개를 작성하세요(영어)"
        introductionTextField.textColor = UIColor.lightGray
        
        profileImageView.layer.cornerRadius = 30
        
        nameTextField.contentVerticalAlignment = .top
        
        loadProfile()
        
        introductionTextField.layer.borderWidth = 1.0 // 테두리의 두께
        introductionTextField.layer.borderColor = UIColor.black.cgColor
        
//         키보드 관련 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowProfile), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        print("Save Profile Button Tapped")

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
                    if let image = UIImage(data: imageData) {
                        profileImageView.image = image
                    } else {
                        print("Failed to create UIImage from data")
                    }
                } else {
                    // 기본 이미지 설정
                    profileImageView.image = UIImage(named: "defaultProfileImage")
                }
                
            } else {
                print("No saved profile data found")
            }
        } catch {
            print("Failed to load profile: \(error)")
        }
    }

    
    @objc func keyboardWillShowProfile(notification: NSNotification) {
        // 필요한 경우 뷰를 올리는 로직 추가
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3  // 뷰를 키보드 높이의 1/3만큼 위로 이동
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
          // 키보드가 사라질 때 뷰를 원래 위치로 되돌리는 로직
          if self.view.frame.origin.y != 0 {
              self.view.frame.origin.y = 0
          }
      }

    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        let contentInsets = UIEdgeInsets.zero
//        UIScroll.contentInset = contentInsets
//        UIScroll.scrollIndicatorInsets = contentInsets
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    


    
    
}


extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for subView in self.subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
}

extension ProfilePageModalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "간단한 자기소개를 작성하세요(영어)"
            textView.textColor = UIColor.lightGray
        }
    }
}

