//
//  WriteReviewViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/24/24.
//

import UIKit
import PhotosUI

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Toast

final class WriteReviewViewController: BaseViewController {
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    private let saveButton = CapsuleButton(title: "저장", backgroudColor: R.Color.red)
    
    private let burgerHouseSearchBar: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "탭하면 햄버거집 검색할 수 있어요"
        return textField
    }()
    
    private let searchBarCover: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = placeholder
        textView.textColor = R.Color.brown.withAlphaComponent(0.5)
        textView.font = R.Font.bold16
        return textView
    }()
    
    private let photoScrollView = UIScrollView()
    private let photoStackView = UIStackView()
    private let addImageView = UIImageView()
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    private let fourthImageView = UIImageView()
    private let fifthmageView = UIImageView()
    private lazy var imageViewList = [addImageView, firstImageView, secondImageView, thirdImageView, fourthImageView, fifthmageView]
    
    private let placeholder = "리뷰를 작성해주세요"
    
    private var tabBar: UITabBarController!
    private var viewModel: WriteReviewViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        tabBar: UITabBarController,
        viewModel: WriteReviewViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> WriteReviewViewController {
        let view = WriteReviewViewController()
        view.tabBar = tabBar
        view.viewModel  = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill")?.withTintColor(R.Color.brown, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "리뷰작성"
    }
    
    override func configureHierarchy() {
        view.addSubview(burgerHouseSearchBar)
        view.addSubview(contentTextView)
        view.addSubview(photoScrollView)
        photoScrollView.addSubview(photoStackView)
        imageViewList.forEach {
            photoStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(120)
            }
            if $0 == addImageView {
                $0.backgroundColor = .gray
                $0.image = UIImage(systemName: "plus.square.fill.on.square.fill")
            } else {
                $0.backgroundColor = R.Color.brown
            }
        }
        view.addSubview(saveButton)
    }
    
    override func configureLayout() {
        burgerHouseSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(burgerHouseSearchBar.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(400)
        }
        
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(120)
        }
        
        photoScrollView.showsHorizontalScrollIndicator = false
        
        photoStackView.snp.makeConstraints { make in
            make.edges.equalTo(photoScrollView)
            make.height.equalTo(120)
        }
        
        photoStackView.spacing = 20
        
        saveButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(photoScrollView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureUI() {
        
    }
}

extension WriteReviewViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.xButtonTap()
            }
            .disposed(by: disposeBag)
        
        searchBarCover.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                print("????")
                owner.viewModel.searchBarTap()
            }
            .disposed(by: disposeBag)
        
        contentTextView.rx.didBeginEditing
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text == owner.placeholder,
                   owner.contentTextView.textColor == R.Color.brown.withAlphaComponent(0.5) {
                    owner.contentTextView.text = nil
                    owner.contentTextView.textColor = R.Color.brown
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    owner.contentTextView.text = owner.placeholder
                    owner.contentTextView.textColor = R.Color.brown.withAlphaComponent(0.5)
                }
            }
            .disposed(by: disposeBag)
        
        firstImageView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                if owner.firstImageView.image != .none {
                    owner.firstImageView.image = nil
                    if owner.addImageView.isHidden {
                        owner.addImageView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        secondImageView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                if owner.secondImageView.image != .none {
                    owner.secondImageView.image = nil
                    if owner.addImageView.isHidden {
                        owner.addImageView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        thirdImageView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                if owner.thirdImageView.image != .none {
                    owner.thirdImageView.image = nil
                    if owner.addImageView.isHidden {
                        owner.addImageView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        addImageView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.imageTap()
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(with: self) { owner, _ in
                let imageData = owner.imageViewList.suffix(5).compactMap { $0.image?.jpegData(compressionQuality: 0.4) }
                owner.viewModel.saveTap(files: imageData)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToPreviousTab
            .bind(with: self) { owner, _ in
                owner.tabBar.selectedIndex = owner.tabBar.previousSelectedIndex
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToLocalSearch
            .bind(with: self) { owner, _ in
                let view = WriteReviewScene.makeView()
                view.didSelectItem = { burgerHouse in
                    owner.viewModel.burgerHouseSelect(burgerHouse: burgerHouse)
                }
                owner.navigationController?.pushViewController(view, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedBurgerHouse
            .bind(to: burgerHouseSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.presentAddPhotoAction
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(
                    title: "사진 추가",
                    message: nil,
                    preferredStyle: .actionSheet
                )
                let camera = UIAlertAction(title: "촬영", style: .default) { _ in
                    owner.viewModel.cameraSelect()
                }
                let gallery = UIAlertAction(title: "앨범", style: .default) { _ in
                    owner.viewModel.gallerySelect()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(camera)
                alert.addAction(gallery)
                alert.addAction(cancel)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.presentCamera
            .bind(with: self) { owner, _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = owner
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.presentGallery
            .bind(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.filter = .any(of: [.images, .screenshots])
                configuration.selectionLimit = 1
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = owner
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5)
            }
            .disposed(by: disposeBag)
    }
}

extension WriteReviewViewController: UINavigationControllerDelegate,
                                     UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            if let image = info[.originalImage] as? UIImage {
                for imageView in imageViewList.suffix(5) {
                    if imageView.image == .none {
                        imageView.image = image
                        break
                    }
                }
            }
            if imageViewList.suffix(5).compactMap({ $0.image }).count == 5 {
                addImageView.isHidden = true
            }
        }
    }
}

extension WriteReviewViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                // UIImage 타입으로 아이템을 로드 즉, 가지고올 수 있느냐의 여부를 먼저 묻고 가져오자
                // image를 가져오는 과정에서 스레드를 백그라운드 스레드로 알아서 돌려주기 때문에 UI처리를 해줄 땐
                // 다시 메인 스레드로 Task를 가져와야 한다
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if let image = image as? UIImage {
                            for imageView in imageViewList.suffix(5) {
                                if imageView.image == .none {
                                    imageView.image = image
                                    break
                                }
                            }
                        }
                        if imageViewList.suffix(5).compactMap({ $0.image }).count == 5 {
                            addImageView.isHidden = true
                        }
                    }
                }
            }
        }
    }
}