//
//  BurgerMapViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit
import CoreLocation
import MapKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class BurgerMapViewController: BaseViewController {
    private let burgerMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    private var viewModel: BurgerMapViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: BurgerMapViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerMapViewController {
        let view = BurgerMapViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        burgerMapView.delegate = self
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(burgerMapView)
    }
    
    override func configureLayout() {
        burgerMapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BurgerMapViewController {
    private func bind() {
        viewModel.viewDidLoad()
        
        viewModel.requestAuthAlert
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                let title = "위치 권한 설정"
                let message = message
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                
                let moveSetting: (UIAlertAction) -> Void = { _ in
                    guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(settingURL) {
                        UIApplication.shared.open(settingURL)
                    }
                }
                
                // 2. alert button 구성
                let move = UIAlertAction(title: "이동", style: .default, handler: moveSetting)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                // 3. alert에 button 추가
                alert.addAction(move)
                alert.addAction(cancel)
                
                owner.present(alert, animated: true)
            } onCompleted: { _ in
                print("requestAuthAlert onCompleted")
            } onDisposed: { _ in
                print("requestAuthAlert onDisposed")
            }
            .disposed(by: disposeBag)
        
        viewModel.setRegion
            .asDriver(onErrorJustReturn: .init(latitude: 37.517742, longitude: 126.886463))
            .drive(with: self) { owner, coordinate in
                let region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
                owner.burgerMapView.setRegion(region, animated: true)
            } onCompleted: { _ in
                print("setRegion completed")
            } onDisposed: { _ in
                print("setRegion disposed")
            }
            .disposed(by: disposeBag)
        
        viewModel.burgerMapHouses
            .bind(with: self) { owner, burgerMapHouses in
                dump(burgerMapHouses)
            }
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToLogin
            .bind(with: self) { owner, _ in
                owner.goToLogin()
            }
            .disposed(by: disposeBag)
    }
}

extension BurgerMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        
        
        return nil
    }
}
