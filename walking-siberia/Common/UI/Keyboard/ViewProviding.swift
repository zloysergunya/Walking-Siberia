//
//  ViewProviding.swift
//  USpeak
//
//  Created by Кирилл on 14.01.2022.
//  Copyright © 2022 SF Labs. All rights reserved.
//

import UIKit

protocol ViewProviding {
    var view: UIView! { get }
}

extension UIViewController: ViewProviding { }

extension UIView: ViewProviding {
    var view: UIView! { self }
}
