//
//  FZLoginController.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/9.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit

class FZLoginController: UIViewController, UITextFieldDelegate {
    
    lazy var userTF: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 20
        tf.layer.masksToBounds = true
        tf.placeholder = "请输入用户名"
        tf.delegate = self
        return tf
    }()
    
    lazy var pwdTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 20
        tf.layer.masksToBounds = true
        tf.placeholder = "请输入密码"
        tf.delegate = self
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
