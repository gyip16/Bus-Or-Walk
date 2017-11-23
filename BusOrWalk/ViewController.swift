//
//  ViewController.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-11-17.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Data
    var RoutesList = [String]()

    //MARK: Properties
    @IBOutlet weak var BusStopNumberLabel: UILabel!
    @IBOutlet weak var BusStopNumberTextField: UITextField!
    @IBOutlet weak var BusStopSpinner: UIActivityIndicatorView!
    @IBOutlet weak var SelectBus: UIButton!

    //MARK: Stying Properties
    let invalidColor : UIColor = UIColor( red: 0.8, green: 0.8, blue:8, alpha: 1.0 )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BusStopNumberTextField.delegate = self
        
        // hide Keyboard on Tap outside of keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        BusStopSpinner.isHidden = true
        SelectBus.isEnabled = false
        SelectBus.backgroundColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide Keyboard on Return
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    //MARK: Bus Stop Number Actions
    @IBAction func getBusStopBusList(_ sender: Any) {
        let a = BusStopDataResponse()
        self.BusStopSpinner.startAnimating()
        self.BusStopSpinner.isHidden = false
        a.loadBusStop(busStopNo: BusStopNumberTextField.text!) { response in
            if let bs = response.value {
                self.RoutesList = bs.Routes!.components(separatedBy: ", ")
                self.SelectBus.isEnabled = true
            } else {
                print("error so i ran")
                self.BusStopNumberTextField.layer.borderColor = self.invalidColor.cgColor
            }
            self.BusStopSpinner.isHidden = true
        }
    }
    
    @IBAction func startBusStopEdit(_ sender: Any) {
        self.SelectBus.isEnabled = false
        self.BusStopNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: Bus Number Actions
    @IBAction func selectingBus(_ sender: Any) {
        
    }
}

