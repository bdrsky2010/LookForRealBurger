//
//  Coordinator.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/10/25.
//

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
