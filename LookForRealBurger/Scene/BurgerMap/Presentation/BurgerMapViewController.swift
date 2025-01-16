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
import RxGesture
import SnapKit
import Toast

final class BurgerMapViewController: BaseViewController {
    private let burgerMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "arrow.clockwise.circle.fill")?.withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 40, weight: .bold))
        return button
    }()
    
    private weak var coordinator: MapNavigation!
    
    private var viewModel: BurgerMapViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        coordinator: MapNavigation,
        viewModel: BurgerMapViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerMapViewController {
        let view = BurgerMapViewController()
        view.coordinator = coordinator
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        burgerMapView.delegate = self
        burgerMapView.register(
            BurgerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: BurgerAnnotationView.identifier
        )
        bind()
        viewModel.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveMap),
            name: Notification.Name("MoveMap"),
            object: nil
        )
    }
    
    @objc
    private func moveMap(_ notification: Notification) {
        guard let burgerHouse = notification.object as? GetBurgerHouse else { return }
        guard let latitude = Double(burgerHouse.latitude), let longitude = Double(burgerHouse.longitude) else {  return}
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        burgerMapView.setRegion(region, animated: false)
    }
    
    override func configureHierarchy() {
        view.addSubview(burgerMapView)
        view.addSubview(refreshButton)
    }
    
    override func configureLayout() {
        burgerMapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(50)
        }
    }
}

extension BurgerMapViewController {
    private func bind() {
        burgerMapView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, recognizer in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        refreshButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.refreshTap()
            }
            .disposed(by: disposeBag)
        
        viewModel.requestAuthAlert
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                let title = R.Phrase.setLocationAccess
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
                let move = UIAlertAction(title: R.Phrase.move, style: .default, handler: moveSetting)
                let cancel = UIAlertAction(title: R.Phrase.cancel, style: .cancel)
                
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
                owner.burgerMapView.setRegion(region, animated: false)
            } onCompleted: { _ in
                print("setRegion completed")
            } onDisposed: { _ in
                print("setRegion disposed")
            }
            .disposed(by: disposeBag)
        
        viewModel.burgerMapHouses
            .bind(with: self) { owner, burgerMapHouses in
                let images = (0..<10).map { "burger\($0)" }
                
                burgerMapHouses.forEach { burgerHouse in
                    let annotation = CustomAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: burgerHouse.latitude,
                            longitude: burgerHouse.longitude
                        ),
                        title: burgerHouse.name,
                        image: images.randomElement(),
                        burgerMapHouse: burgerHouse
                    )
                    owner.burgerMapView.addAnnotation(annotation)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.showBurgerMapHouseModel
            .bind(with: self) { owner, burgerMapHouse in
                let vc = BurgerMapScene.makeView(
                    coordinator: owner.coordinator,
                    burgerMapHouse: burgerMapHouse
                )
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToLogin
            .bind(with: self) { owner, _ in
                owner.goToLogin { [weak owner] in
                    owner?.coordinator.goToLogin()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.removeAnnotations
            .bind(with: self) { owner, _ in
                let annotations = owner.burgerMapView.annotations
                owner.burgerMapView.removeAnnotations(annotations)
            }
            .disposed(by: disposeBag)
    }
}

extension BurgerMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        // 다운캐스팅이 되면 CustomAnnotation를 갖고 CustomAnnotationView를 생성
        if let customAnnotation = annotation as? CustomAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: BurgerAnnotationView.identifier,
                for: customAnnotation
            )
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        guard let annotation = annotation as? CustomAnnotation else { return }
        viewModel.didSelectBurgerMapHouse(annotation.burgerMapHouse)
    }
}
