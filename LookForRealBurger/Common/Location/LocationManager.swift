//
//  LocationManager.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import CoreLocation

import RxCocoa
import RxCoreLocation
import RxSwift

protocol LocationManager {
    var requestAuthAlert: PublishRelay<String> { get }
    var coordinate: BehaviorRelay<CLLocationCoordinate2D> { get }
    
    func checkDeviceLocationAuthorization()
}

final class DefaultLocationManager {
    static let shared = DefaultLocationManager()
    
    private let manager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    var requestAuthAlert = PublishRelay<String>()
    var coordinate = BehaviorRelay<CLLocationCoordinate2D>(value: .init(latitude: 37.517742, longitude: 126.886463))
    
    private init() {
        bind()
    }
}

extension DefaultLocationManager: LocationManager {
    // 1) 사용자에게 권한 요청을 하기 위해, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if CLLocationManager.locationServicesEnabled() {
                checkCurrentLocationAuthorization()
            } else {
                requestAuthAlert.accept("아이폰 위치 서비스가 켜져있어야 위치 확인이 가능합니다. 설정 -> 개인정보 보호 및 보안 -> 위치 서비스 -> 활성화")
            }
        }
    }
    
    // 2) 현재 사용자 위치 권한 상태 확인
    private func checkCurrentLocationAuthorization() {
        print(#function)
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // 3) notDetermined 상태일 때 권한을 요청
            print("notDetermined")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("denied")
            requestAuthAlert.accept("위치 권한을 허용해야만 위치 확인이 가능합니다.")
        case .authorizedAlways, .authorizedWhenInUse:
            // 4) authorized 상태일 때 위치 정보 업데이트가 시작할 수 있도록 요청
            print("authorized")
            manager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    private func bind() {
        manager.rx
            .didUpdateLocations
            .bind(with: self) { owner, locations in
                guard let current = locations.locations.last else { return }
                print("didUpdateLocations")
                owner.coordinate.accept(current.coordinate)
                owner.manager.stopUpdatingLocation()
            }
            .disposed(by: disposeBag)
        
        manager.rx
            .didChangeAuthorization
            .bind(with: self) { owner, authorization in
                print("didChangeAuthorization")
                owner.checkDeviceLocationAuthorization()
            }
            .disposed(by: disposeBag)
    }
}

extension LocationManager {
    func setAuthrized(_ flag: Bool) { }
}

final class MockLocationManager: LocationManager {
    private let disposeBag = DisposeBag()
    private var isAuthorized = false
    
    var requestAuthAlert = PublishRelay<String>()
    var coordinate = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    func checkDeviceLocationAuthorization() {
        if isAuthorized {
            requestAuthAlert.accept("")
        } else {
            coordinate.accept(CLLocationCoordinate2D(latitude: 1, longitude: 1))
        }
    }
    
    func setAuthrized(_ flag: Bool) { isAuthorized = flag }
}
