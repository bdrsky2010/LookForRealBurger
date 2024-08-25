//
//  WriteReviewScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import UIKit

enum WriteReviewScene {
    static func makeView(tabBar: UITabBarController) -> WriteReviewViewController {
        let view = WriteReviewViewController.create(tabBar: tabBar)
        return view
    }
    
    static func makeView() -> SearchBurgerHouseViewController {
        let localSearchRepository = KakaoLocalSearchRepository()
        let localSearchUseCase = DefaultLocalSearchUseCase(localSearchRepository: localSearchRepository)
        let locationManager = DefaultLocationManager.shared
        let viewModel = DefaultSearchBurgerHouseViewModel(
            localSearchUseCase: localSearchUseCase,
            locationManager: locationManager
        )
        let view = SearchBurgerHouseViewController.create(viewModel: viewModel)
        return view
    }
}
