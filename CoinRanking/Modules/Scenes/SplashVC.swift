//
//  SplashVC.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit
import Lottie

class SplashVC: UIViewController, Onboarded {

    //MARK: - Properties
    var coordinator: MainCoordinator?
    
    @IBOutlet weak var animView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var textInfo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    // MARK: - Variables
    var splashAnimation: LottieAnimationView?
    var timer = Timer()
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat
        
        topSafeArea = view.safeAreaInsets.top
        bottomSafeArea = view.safeAreaInsets.bottom
        
        SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        SCREEN_WIDTH = UIScreen.main.bounds.size.width
        
        TOP_SAFEAREA_HEIGHT = topSafeArea
        BOTTOM_SAFEAREA_HEIGHT = bottomSafeArea
        
        debugPrint("TOP SAFEAREA HEIGHT -> \(TOP_SAFEAREA_HEIGHT)")
        debugPrint("BOTTOM SAFEAREA HEIGHT -> \(BOTTOM_SAFEAREA_HEIGHT)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //navigationController?.isNavigationBarHidden = true
        textInfo.isHidden = true
        showSplashAnimation()
    }
    
    func showSplashAnimation() {
        let animeJson = "splash_animation"
        splashAnimation = LottieAnimationView(name: animeJson)
                
        guard let splashAnimation = splashAnimation else { return }

        splashAnimation.frame = CGRect(x: 0, y: 0, width: 200.0, height: 200.0)
        animView.addSubview(splashAnimation)
        splashAnimation.contentMode = .scaleToFill
        splashAnimation.animationSpeed = 0.3
        splashAnimation.play(completion: { [weak self] finished in
            self?.splashAnimation = nil
            self?.proceed()
        })
    }
    
    func proceed() {
        progressView.showProgressBar()
        // Check internet connectivity before proceeding
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.coordinator?.openDashboard()
            })
        } else {
            textInfo.isHidden = false
            textInfo.text = "Please make sure you are connected to the internet"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.textInfo.text = "Trying to establish connection"
                self.scheduledTimerWithTimeInterval()
            })
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateCounting() {
        NSLog("counting..")
        if NetworkMonitor.shared.isConnected {
            //Do any additional setup after loading the view.
            textInfo.isHidden = false
            textInfo.text = "Connection established"
            timer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.coordinator?.openDashboard()
            })
            debugPrint("Internet Connection Available!")
            
        } else {
            textInfo.isHidden = false
            textInfo.text = "Retrying..."
            debugPrint("Retrying!")
        }
    }
    
    deinit {
        timer.invalidate()
        splashAnimation?.removeFromSuperview()
    }
}
