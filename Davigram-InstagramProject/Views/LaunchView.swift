//
//  LaunchView.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class LaunchView: UIView {

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "A NEW WAY TO GRAM..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        return label
    }()
    
    private lazy var subTitle: UILabel = {
       let label = UILabel()
        label.text = "DAVIGRAM"
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(30)
        return label
    }()
    
    private lazy var launchView: Lottie.AnimationView = {
        let lottieAnimationView = Lottie.AnimationView()
        lottieAnimationView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return lottieAnimationView
    }()
    
    
    public func startAnimation() {
        launchView.animation = Animation.named("launch", subdirectory: nil)
        launchView.play()
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commonInit()
    }
    
    
    private func commonInit() {
        animationViewConstraint()
        setupTitleConstraint()
        setupSubtitleConstraint()
    }
    
    private func animationViewConstraint() {
        addSubview(launchView)
        launchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -100),
            launchView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            launchView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            launchView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 100)
        ])
    }
    
    private func setupTitleConstraint() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            
        }
    }
    
    private func setupSubtitleConstraint() {
        addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            
        }
    }

}
