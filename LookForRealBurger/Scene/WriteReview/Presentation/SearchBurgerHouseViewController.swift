//
//  WriteReviewViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import SnapKit

final class SearchBurgerHouseViewController: BaseViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.font = R.Font.chab16
        searchBar.searchTextField.textColor = R.Color.brown
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Look For Real Burger", attributes: [NSAttributedString.Key.font: R.Font.chab16, NSAttributedString.Key.foregroundColor: R.Color.brown.withAlphaComponent(0.5)])
        return searchBar
    }()
    private let localSearchTableView = UITableView()
    
    private var viewModel: SearchBurgerHouseViewModel!
    private var disposeBag: DisposeBag!
    
    var didSelectItem: ((BurgerHouse) -> Void)?
    
    static func create(
        viewModel: SearchBurgerHouseViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> SearchBurgerHouseViewController {
        let view = SearchBurgerHouseViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
        setupBackButton()
        navigationItem.titleView = searchBar
        
        let rightBarButtonItem = UIBarButtonItem(title: "검색", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: R.Font.chab18, NSAttributedString.Key.foregroundColor: R.Color.brown], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: R.Font.chab18, NSAttributedString.Key.foregroundColor: R.Color.brown.withAlphaComponent(0.5)], for: .disabled)
    }
    
    override func configureHierarchy() {
        view.addSubview(localSearchTableView)
    }
    
    override func configureLayout() {
        localSearchTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        localSearchTableView.backgroundColor = .clear
        localSearchTableView.rowHeight = UITableView.automaticDimension
        localSearchTableView.keyboardDismissMode = .interactive
        localSearchTableView.register(
            LocalSearchTableViewCell.self,
            forCellReuseIdentifier: LocalSearchTableViewCell.identifier
        )
    }
}

extension SearchBurgerHouseViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapBack()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.didChangeText(text: text)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                owner.viewModel.searchText(type: .search, text: text)
                owner.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        localSearchTableView.rx.modelSelected(BurgerHouse.self)
            .bind(with: self) { owner, burgerHouse in
                owner.viewModel.modelSelected(item: burgerHouse)
            }
            .disposed(by: disposeBag)
        
        viewModel.popView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.isSearchEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isEnabled in
                owner.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        viewModel.burgerHouses
            .bind(to: localSearchTableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LocalSearchTableViewCell.identifier) as? LocalSearchTableViewCell else { return UITableViewCell() }
                let colors = [R.Color.orange, R.Color.red, R.Color.yellow, R.Color.green, R.Color.brown]
                cell.configureContent(with: element, color: colors[row % 5])
                cell.backgroundColor = .clear
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.selectItem
            .bind(with: self) { owner, burgerHouse in
                owner.didSelectItem?(burgerHouse)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        localSearchTableView.rx.prefetchRows
            .withLatestFrom(searchBar.rx.text.orEmpty) { (indexPaths: $0, text: $1) }
            .bind(with: self) { owner, tuple in
                for indexPath in tuple.indexPaths {
                    if indexPath.row == ((owner.viewModel.nextPage - 1) * 14) - 1 {
                        owner.viewModel.searchText(type: .pagination, text: tuple.text)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
