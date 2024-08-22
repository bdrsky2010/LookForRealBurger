//
//  JoinCompleteViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/20/24.
//

import UIKit

import Lottie
import RxCocoa
import RxSwift
import SnapKit

final class JoinCompleteViewController: BaseViewController {
    private let congratulationLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.Color.brown
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = R.Font.chab40
        return label
    }()
    
    private let burgerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "cartoon_burger")
        return imageView
    }()
    
    private let goToLoginButton = PretendardRoundedButton(
        title: "로그인 하러가기", backgroudColor: R.Color.red
    )
    
    private var user: JoinUser!
    private var disposeBag: DisposeBag!
    
    static func create(
        user: JoinUser,
        disposeBag: DisposeBag = DisposeBag()
    ) -> JoinCompleteViewController {
        let view = JoinCompleteViewController()
        view.user = user
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFireworkAnimation()
        
        goToLoginButton.rx.tap
            .bind(with: self) { owner, _ in
                let loginViewController = LoginScene.makeView()
                owner.changeRootViewController(loginViewController)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configureHierarchy() {
        view.addSubview(congratulationLabel)
        view.addSubview(burgerImage)
        view.addSubview(goToLoginButton)
    }
    
    override func configureLayout() {
        congratulationLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(burgerImage.snp.top).offset(-16)
        }
        
        burgerImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(200)
        }
        
        goToLoginButton.snp.makeConstraints { make in
            make.top.equalTo(burgerImage.snp.bottom).offset(16)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        congratulationLabel.text = R.Phrase.getCongratulation(nick: user.nick)
    }
    
    private func startFireworkAnimation() {
        let fireworkAnimationView = LottieAnimationView(name: "fireworkAnimation")
        view.addSubview(fireworkAnimationView)
        fireworkAnimationView.frame = view.bounds
        fireworkAnimationView.center = view.center
        fireworkAnimationView.contentMode = .scaleAspectFit
        fireworkAnimationView.loopMode = .playOnce
        fireworkAnimationView.play { completed in
            fireworkAnimationView.isHidden = completed
        }
    }
}
