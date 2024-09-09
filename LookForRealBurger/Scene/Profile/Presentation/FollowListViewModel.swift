//
//  FollowListViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol FollowListInput {
    func viewDidLoad()
    func modelSelected(follow: GetFollow)
}

protocol FollowListOutput {
    var configureTableView: BehaviorRelay<[GetFollow]> { get }
    var pushProfileView: PublishRelay<ProfileType> { get }
}

typealias FollowListViewModel = FollowListInput & FollowListOutput

final class DefaultFollowListViewModel: FollowListOutput {
    private let disposeBag: DisposeBag
    private let myUserId: String
    private let followList: [GetFollow]
    
    var configureTableView = BehaviorRelay<[GetFollow]>(value: [])
    var pushProfileView = PublishRelay<ProfileType>()
    
    init(
        disposBag: DisposeBag = DisposeBag(),
        myUserId: String,
        followList: [GetFollow]
    ) {
        self.disposeBag = disposBag
        self.myUserId = myUserId
        self.followList = followList
    }
}

extension DefaultFollowListViewModel: FollowListInput {
    func viewDidLoad() {
        configureTableView.accept(followList)
    }
    
    func modelSelected(follow: GetFollow) {
        if follow.userId == myUserId {
            pushProfileView.accept(.me(myUserId))
        } else {
            pushProfileView.accept(.other(follow.userId, myUserId))
        }
    }
}
