//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 27/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTitleLabel.text = "Surel"
        passwordTitleLabel.text = "Kata Sandi"
        loginButton.setTitle("Masuk", for: UIControl.State.normal)
        loginButton.layer.cornerRadius = 8
        
        ApiService.shared.loadNews { result in
            switch result {
            case .success(let newsList):
                print("---- Num Results: \(newsList.count)")
                print(newsList)
                self.emailTextField.text = "Num Results: \(newsList.count)"
            case .failure(let error):
                print("this is error \(error)")
            }
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Email:  \(emailTextField.text ?? "-")")
    }
    
}

