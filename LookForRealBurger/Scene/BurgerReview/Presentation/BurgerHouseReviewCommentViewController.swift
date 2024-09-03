//
//  BuregerHouseReviewCommentViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class BurgerHouseReviewCommentViewController: BaseViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = R.Font.chab20
        label.textColor = R.Color.brown
        label.textAlignment = .center
        return label
    }()
    
    private let commentTableView = UITableView()
    
    private let commentTextViewBackgroundView = UIView()
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.text = placeholder
        textView.textColor = R.Color.brown.withAlphaComponent(0.5)
        textView.font = R.Font.regular14
        return textView
    }()
    private let sendButton = CapsuleButton(title: "전송", font: R.Font.bold14, backgroudColor: R.Color.green)
    private let textViewCoverLable = UILabel()
    
    private let placeholder = "댓글 추가"
    
    private var viewModel: BurgerHouseReviewCommentViewModel!
    private var disposeBag: DisposeBag!
    
    var onChangeComments: ((_ comments: [Comment]) -> Void)?
    
    static func create(
        viewModel: BurgerHouseReviewCommentViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerHouseReviewCommentViewController {
        let view = BurgerHouseReviewCommentViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
        }
        
        configureTableView()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func configureNavigation() {
        navigationItem.title = "댓글"
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(commentTableView)
        view.addSubview(commentTextViewBackgroundView)
        commentTextViewBackgroundView.addSubview(commentTextView)
        commentTextViewBackgroundView.addSubview(sendButton)
        commentTextViewBackgroundView.addSubview(textViewCoverLable)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        commentTextViewBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(33)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(commentTextView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.trailing.equalToSuperview()
        }
        
        textViewCoverLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = R.Color.orange.cgColor
        commentTextView.layer.cornerRadius = 10
    }
    
    private func configureTableView() {
        commentTableView.register(ReviewCommentTableViewCell.self, forCellReuseIdentifier: ReviewCommentTableViewCell.identifier)
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.backgroundColor = .clear
    }
}

extension BurgerHouseReviewCommentViewController {
    private func bind() {
        sendButton.rx.tap
            .withLatestFrom(commentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                owner.viewModel.sendButtonTap(text: text)
                
                owner.commentTextView.text = nil
                if let font = owner.commentTextView.font {
                    let size = CGSize(width: owner.commentTextView.frame.width, height: font.lineHeight)
                    let estimatedSize = owner.commentTextView.sizeThatFits(size)
                    
                    owner.commentTextView.constraints.forEach { constraint in
                        
                        if constraint.firstAttribute == .height {
                            
                            constraint.constant = estimatedSize.height
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.didBeginEditing
            .withLatestFrom(commentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text == owner.placeholder,
                   owner.commentTextView.textColor == R.Color.brown.withAlphaComponent(0.5) {
                    owner.commentTextView.text = nil
                    owner.commentTextView.textColor = R.Color.brown
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.didEndEditing
            .withLatestFrom(commentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    owner.commentTextView.text = owner.placeholder
                    owner.commentTextView.textColor = R.Color.brown.withAlphaComponent(0.5)
                    owner.sendButton.isEnabled = false
                } else {
                    owner.sendButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
        
        commentTextView.rx.didChange
            .withLatestFrom(commentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                guard let font = owner.commentTextView.font else { return }

                let size = CGSize(width: owner.commentTextView.frame.width, height: .infinity)
                let estimatedSize = owner.commentTextView.sizeThatFits(size)
                let numberOfLines = Int(estimatedSize.height / font.lineHeight)
                
                owner.commentTextView.constraints.forEach { constraint in
                    
                    if constraint.firstAttribute == .height && numberOfLines <= 3 {
                        constraint.constant = estimatedSize.height
                    } else if numberOfLines > 3 {
                        owner.commentTextView.isScrollEnabled = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let comments = viewModel.configureComments
            .asDriver(onErrorJustReturn: [])
        
        comments
            .drive(commentTableView.rx.items) { (tableView, row, item) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCommentTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? ReviewCommentTableViewCell else { return UITableViewCell() }
                
                cell.configureContent(comment: item)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: disposeBag)
        
        comments
            .drive(with: self) { owner, comments in
                owner.onChangeComments?(comments)
            }
            .disposed(by: disposeBag)
    }
}
