//
//  PaymentScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 11.12.2024.
//

import UIKit

class PaymentScreenViewController: UIViewController {
    
    var paymentScreenView: PaymentScreenView!
    
    override func loadView() {

        paymentScreenView = PaymentScreenView(frame: UIScreen.main.bounds)
        self.view = paymentScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
    }
}
