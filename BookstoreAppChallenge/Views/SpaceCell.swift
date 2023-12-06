//
//  SpaceCell.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 07.12.2023.
//

import UIKit

typealias SpaceCell = TableCell<SpaceView>

final class SpaceView: UIView, Configurable {
    struct Model {
        let height: CGFloat
    }
    
    func update(model: Model) {
        snp.makeConstraints {
            $0.height.equalTo(model.height)
        }
    }
}
