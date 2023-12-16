//
//  CustomTabBar.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 16.12.23.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 90
        return sizeThatFits
    }
}
