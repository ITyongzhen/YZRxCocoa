//
//  SimpleValidationViewModel.swift
//  userNameAndPassWord
//
//  Created by yongzhen on 2018/9/3.
//  Copyright © 2018年 yongzhen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class SimpleValidationViewModel: NSObject {
    
    // 输出
    let userNameValid : Observable<Bool>
    let passWordValid :Observable<Bool>
    let everyThingValid : Observable<Bool>
    init(userName: Observable<String>, passWord: Observable<String>) {
        let minUserNameLength = 5
        let minPassWordLength = 6
        userNameValid = userName.map { $0.count >= minUserNameLength }.share(replay: 1)
        passWordValid = passWord.map { $0.count >= minPassWordLength }.share(replay: 1)
        everyThingValid = Observable.combineLatest(userNameValid, passWordValid) { $0 && $1 }
            .share(replay: 1)
        super.init()
    }
    
}
