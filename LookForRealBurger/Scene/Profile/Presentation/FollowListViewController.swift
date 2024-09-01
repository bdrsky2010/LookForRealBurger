//
//  FollowListViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class FollowListViewController: BaseViewController {
    private let followTableView = UITableView()
    
    private var viewModel: FollowListViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: FollowListViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> FollowListViewController {
        let view = FollowListViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(followTableView)
        followTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        followTableView.register(
            FollowListTableViewCell.self,
            forCellReuseIdentifier: FollowListTableViewCell.identifier
        )
        followTableView.backgroundColor = .clear
        followTableView.rowHeight = UITableView.automaticDimension
        
        viewModel.viewDidLoad()
        
        followTableView.rx.modelSelected(GetFollow.self)
            .bind(with: self) { owner, follow in
                owner.viewModel.modelSelected(follow: follow)
            }
            .disposed(by: disposeBag)
        
        viewModel.configureTableView
            .bind(to: followTableView.rx.items) { (tableView, row, item) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowListTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? FollowListTableViewCell else { return UITableViewCell()}
                let colors = [R.Color.orange, R.Color.red, R.Color.yellow, R.Color.green, R.Color.brown]
                cell.setContent(nick: item.nick, textColor: colors[row % 5])
                cell.backgroundColor = .clear
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.pushProfileView
            .bind(with: self) { owner, type in
                let view = ProfileScene.makeView(profileType: type)
                owner.navigationController?.pushViewController(view, animated: true)
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
