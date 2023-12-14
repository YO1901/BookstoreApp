//
//  LoadingView.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 14.12.2023.
//

import UIKit

final class LoadingView: UIView {
    
    private let loadingImage: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = Colors.blackPrimary
        iv.image = Images.loading.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(loadingImage)
        loadingImage.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
    
    func startAnimation() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .greatestFiniteMagnitude
        loadingImage.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() {
        loadingImage.layer.removeAllAnimations()
    }
}
