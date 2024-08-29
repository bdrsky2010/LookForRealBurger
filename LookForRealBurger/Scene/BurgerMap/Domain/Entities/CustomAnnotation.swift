//
//  BurgerAnnotation.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: String?
    var burgerMapHouse: BurgerMapHouse
    
    init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        image: String?,
        burgerMapHouse: BurgerMapHouse
    ) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.burgerMapHouse = burgerMapHouse
    }
}
