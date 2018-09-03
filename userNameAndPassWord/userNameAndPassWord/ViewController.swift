//
//  ViewController.swift
//  userNameAndPassWord
//
//  Created by yongzhen on 2018/8/28.
//  Copyright © 2018年 yongzhen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var passWordLabel: UILabel!
    
    
    @IBOutlet weak var button: UIButton!
    
      let disposeBag = DisposeBag()
    
    private var viewModel: SimpleValidationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // MVC
        putIntUserNameAndPassWord2()
        
    }
    
    
    func putIntUserNameAndPassWord3()  {
        
    }
    
    func putIntUserNameAndPassWord2() {
        let minUserNameLength = 5
        let minPassWordLength = 6
        
        userNameLabel.text = "userName has to be at least \(minUserNameLength) characters"
        passWordLabel.text = "passWord has to be at least \(minPassWordLength) characters"
        // 用户名是否有效
        let usernameValid = userNameTextField.rx.text.orEmpty.map{ $0.count >= minUserNameLength}.share(replay: 5)
        // 密码是否有效
        let passWordValid = passWordTextField.rx.text.orEmpty.map{ $0.count >= minPassWordLength}.share(replay: 1)
        
        // 所有输入是否有效
        let everythingValid = Observable.combineLatest(usernameValid,passWordValid){ $0 && $1 }.share(replay: 1)
        
        // 用户名是否有效 -> 密码输入框是否可用
        usernameValid.bind(to: passWordTextField.rx.isEnabled).disposed(by: disposeBag)
        // 用户名是否有效 -> 用户名提示语是否隐藏
        usernameValid.bind(to: userNameLabel.rx.isHidden).disposed(by: disposeBag)
        // 密码是否有效 -> 密码提示语是否隐藏
        passWordValid.bind(to: passWordLabel.rx.isHidden).disposed(by: disposeBag)
        
        // 所有输入是否有效 -> 按钮是否可点击
        everythingValid.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        //点击按钮 -> 弹出提示框
        button.rx.tap.subscribe(onNext: {[weak self] in self?.showAlert()}).disposed(by: disposeBag)
    }
    
    
    
    
    func putIntUserNameAndPassWord() {
        let minimalUsernameLength = 5
        let minimalPasswordLength = 6
        // Do any additional setup after loading the view, typically from a nib.
        userNameLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passWordLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = userNameTextField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passWordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(
            usernameValid,
            passwordValid
        ) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passWordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: userNameLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passWordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

