//  Copyright © 2017 Philips. All rights reserved.

import UIKit

protocol Storyboarding {
    associatedtype T: UIViewController

    static var storyboardIdentifier: String { get }
    static var storyboardBundle: Bundle { get }

    static func fromStoryboard() -> T?
}

extension Storyboarding {

    static var storyboardIdentifier: String {
        return String(describing: T.self)
    }

    static var storyboardBundle: Bundle {
        return Bundle(for: T.self)
    }

    static func fromStoryboard() -> Self? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instance = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
        return instance as? Self
    }
}
