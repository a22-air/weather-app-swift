//
//  ViewController.swift
//  SampleCreate
//
//  Created by taniguchi.airi on 2024/09/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var num1: UITextField!
    @IBOutlet weak var num2: UITextField!
    @IBOutlet weak var back: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        num1.placeholder = "数字を入力してください"
        num2.placeholder = "数字を入力してください"
    }


    @IBAction func sum(_ sender: Any) {
        
        let no1 = Double(num1.text ?? "") ?? 0.0
        let no2 = Double(num2.text ?? "") ?? 0.0
        
        let sumResult = no1 + no2
        
        result.text = "\(sumResult)"
    }
   
}

