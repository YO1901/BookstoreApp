//
//  DSGradientView.swift
//  DSUI
//
//  Created by Victor on 16.12.2023.
//

import UIKit

public final class GradientView: UIView {
    
    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    var colors: [UIColor] = [] {
        didSet {
            (layer as? CAGradientLayer)?.colors = colors.map { $0.cgColor }
        }
    }
    
    var startPoint: CGPoint = .init(x: 0.5, y: 0) {
        didSet {
            (layer as? CAGradientLayer)?.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = .init(x: 0.5, y: 1) {
        didSet {
            (layer as? CAGradientLayer)?.endPoint = endPoint
        }
    }
    
    var locations: [NSNumber]? {
        didSet {
            (layer as? CAGradientLayer)?.locations = locations
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection != traitCollection else {
            return
        }
        
        (self.layer as? CAGradientLayer)?.colors = self.colors.map { $0.cgColor }
    }
}
