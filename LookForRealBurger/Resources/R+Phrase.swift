//
//  R+Phrase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation

extension R {
    enum Phrase { }
}

extension R.Phrase {
    static let emailPlaceholder = "emailPlaceholder".localized
    static let passwordPlaceholder = "passwordPlaceholder".localized
    static let nickPlaceholder = "nickPlaceholder".localized
    
    static let errorOccurred = "errorOccurred".localized
    static let networkUnstable = "networkUnstable".localized
    static let expiredLogin = "expiredLogin".localized
    static let expiredLoginExplain = "expiredLoginExplain".localized
    static let failGetMyProfile = "failGetMyProfile".localized
    static let notFoundPost = "notFoundPost".localized
    static let notFoundUser = "notFoundUser".localized
    
    static let missingFieldError = "missingFieldError".localized
    static let existBlankNick = "existBlankNick".localized
    static let alreadyAccount = "alreadyAccount".localized
    static let accountVerifyError = "accountVerifyError".localized
    
    static let notCorrectFileType = "notCorrectFileType".localized
    static let serverErrorOccurred = "serverErrorOccurred".localized
    
    static let modifyNick = "modifyNick".localized
    static let followRequest = "followRequest".localized
    static let followCancel = "followCancel".localized
    
    static let logout = "logout".localized
    static let withdraw = "withdraw".localized
    static let support = "support".localized
    static let successfulPayment = "successfulPayment".localized
    static let failedPayment = "failedPayment".localized
    static let logoutComment = "logoutComment".localized
    static let check = "check".localized
    static let cancel = "cancel".localized
    static let follower = "follower".localized
    static let following = "following".localized
    static let review = "review".localized
    static let like = "like".localized
    static let bookmark = "bookmark".localized
    
    static let missingReviewField = "missingReviewField".localized
    static let whyErrorHere = "whyErrorHere".localized
    static let plzSelectBurgerHouse = "plzSelectBurgerHouse".localized
    static let plzImageUpload = "plzImageUpload".localized
    static let limitImageSize = "limitImageSize".localized
    
    static let setLocationAccess = "setLocationAccess".localized
    static let move = "move".localized
    
    static let saveComment = "saveComment".localized
    static let save = "save".localized
    static let addImage = "addImage".localized
    static let camera = "camera".localized
    static let gallery = "gallery".localized
    static let tappedBurgerHouseComment = "tappedBurgerHouseComment".localized
    static let title = "title".localized
    static let plzWriteReview = "plzWriteReview".localized
    static let writeReview = "writeReview".localized
    
    static let noSearchResult = "noSearchResult".localized
    static let wrongSearchText = "wrongSearchText".localized
    static let unstableConnection = "unstableConnection".localized
    static let checkSearchService = "checkSearchService".localized
    
    static let failedGetBurgerHouse = "failedGetBurgerHouse".localized
    
    static let comment = "comment".localized
    static let send = "send".localized
    static let addComment = "addComment".localized
    
    static let moveTo = "moveTo".localized
    
    static let burgerReview = "burgerReview".localized
    
    static let burgerMap = "burgerMap".localized
    static let profile = "profile".localized
    
    static let goToLogin = "goToLogin".localized
    
    static let joinCheck = "joinCheck".localized
    static let joinCheckComment = "joinCheckComment".localized
    static let join = "join".localized
    static let joinTitle = "joinTitle".localized
    static let emailValidTitle = "emailValidTitle".localized
    
    static let login = "login".localized
    
    static func getCongratulation(nick: String) -> String {
        return "congratulation".localized(nick)
    }
    
    static func getProfileComment(nick: String) -> String {
        return "profileComment".localized(nick)
    }
}
