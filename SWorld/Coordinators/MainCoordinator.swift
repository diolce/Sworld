//
//  MainCoordinator.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ListMoviesViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func seeMovie(id:Int) {
        let vc = DetailMovieViewController()
        vc.coordinator = self
        vc.movieId = id
        navigationController.pushViewController(vc, animated: true)
    }
}
