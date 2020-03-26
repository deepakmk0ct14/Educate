//
//  KeyboardToolbarButton.swift
//  Educate
//
//  Created by Deepak on 3/26/20.
//  Copyright © 2020 Deepak. All rights reserved.
//

import UIKit

enum KeyboardToolbarButton: Int {

    case done = 0
    case cancel
    case back, backDisabled
    case forward, forwardDisabled

    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        switch self {
            case .back: button = .init(title: "Back", style: .plain, target: target, action: action)
            case .backDisabled:
                button = .init(title: "Back", style: .plain, target: target, action: action)
                button.isEnabled = false
            case .forward: button = .init(title: "Forward", style: .plain, target: target, action: action)
            case .forwardDisabled:
                button = .init(title: "Forward", style: .plain, target: target, action: action)
                button.isEnabled = false
            case .done: button = .init(title: "Done", style: .plain, target: target, action: action)
            case .cancel: button = .init(title: "Cancel", style: .plain, target: target, action: action)
        }
        button.tag = rawValue
        return button
    }

    static func detectType(barButton: UIBarButtonItem) -> KeyboardToolbarButton? {
        return KeyboardToolbarButton(rawValue: barButton.tag)
    }
}
