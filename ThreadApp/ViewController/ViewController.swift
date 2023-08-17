//
//  ViewController.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 바 컨트롤러의 델리게이트로 현재 뷰 컨트롤러를 설정
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 중간의 탭 바 아이템이 선택되었을 경우
        if viewController is CreateViewController {
            
            // UserDefaults 갱신 코드 추가
            print("새글작성 탭 선택")
            // 여기에 필요한 UserDefaults 갱신 코드를 추가합니다.
            
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            if let modalViewController = storyboard.instantiateInitialViewController() {
                present(modalViewController, animated: true, completion: nil)
                return false  // 탭 변경을 방지
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 탭이 선택될 때마다 호출됩니다.
        
        switch viewController {
            case is UINavigationController:
                // "메인페이지" 탭이 선택되었을 때 수행될 작업
                print("메인페이지 탭 선택")
                
                if let navController = viewController as? UINavigationController,
                   let mainPage = navController.viewControllers.first as? MainViewController {
                    // 메인 페이지에서 스레드 데이터를 새로고침합니다.
                    mainPage.refreshThreads()
                }
            
        case is ProfilePage:
            // "프로필" 탭이 선택되었을 때 수행될 작업
            print("프로필 탭 선택")
            if let profilePage = viewController as? ProfilePage {
                // 프로필 페이지에서 스레드 데이터를 새로고침합니다.
                profilePage.refreshThreads()
            }
            
        default:
            break
        }
    }
    
    
    
}

