//
//  LoginVC.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import Lottie


class LoginVC: UIViewController {
    @IBOutlet weak var animationView: Lottie.AnimationView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewWillLayoutSubviews() {
        containerView.layer.cornerRadius = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("LaunchAnimation", subdirectory: nil)
        animationView.loopMode = .loop
        animationView.play()
    }

}
