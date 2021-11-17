//
//  Coordinator.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
