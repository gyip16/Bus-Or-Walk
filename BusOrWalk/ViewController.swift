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

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    
    //MARK: Data
    var RoutesList = [String]()
    var SelectedRoute = String()
    
    //MARK: Picker Data
    var pickerDataSource = [String]()

    //MARK: Properties
    @IBOutlet weak var BusStopNumberLabel: UILabel!
    @IBOutlet weak var BusStopNumberTextField: UITextField!
    @IBOutlet weak var BusStopSpinner: UIActivityIndicatorView!
    @IBOutlet weak var SelectBus: UIButton!
    @IBOutlet weak var BusSelectedLabel: UILabel!
    
    
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
        // Adds Done Button
        self.addDoneButtonOnKeyboard()
        // Spinner
        BusStopSpinner.isHidden = true
        SelectBus.isEnabled = false
        SelectBus.backgroundColor = UIColor.lightGray
        checkNetwork()
        

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
    
    //MARK: Keyboard Functions
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.BusStopNumberTextField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.BusStopNumberTextField.resignFirstResponder()
    }
    
    //MARK: Bus Stop Number Actions
    @IBAction func getBusStopBusList(_ sender: Any) {
        let a = BusStopDataResponse()
        self.BusStopSpinner.startAnimating()
        self.BusStopSpinner.isHidden = false
        a.loadBusStop(busStopNo: BusStopNumberTextField.text!) { response in
            if let bs = response.value {
                self.RoutesList = bs.Routes!.components(separatedBy: ", ")
                self.pickerDataSource = self.RoutesList
                self.SelectBus.isEnabled = true
                UIView.animate(withDuration: 0.5) {
                    self.SelectBus.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
                }
            } else {
                print("error so i ran")
                self.BusStopNumberTextField.layer.borderColor = self.invalidColor.cgColor
            }
            self.BusStopSpinner.isHidden = true
        }
    }
    // resets the form
    @IBAction func startBusStopEdit(_ sender: Any) {
        SelectBus.isEnabled = false
        BusStopNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        BusSelectedLabel.text! = "No Bus Selected"
        SelectedRoute = String()
    }
    
    //MARK: Bus Number Actions
    @IBAction func selectingBus(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 275)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 275))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Select a Bus", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Select", style: .default, handler: { action in
            self.BusSelectedLabel.text! = self.SelectedRoute
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    //MARK: Picker Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        SelectedRoute = pickerDataSource[row] as String
    }
    
    //MARK: Internet Connectivity Check
    func checkNetwork() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }else{
            print("Internet Connection not Available!")
            SelectBus.isEnabled = false
            BusStopNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
            BusSelectedLabel.text! = "No Bus Selected"
            SelectedRoute = String()
            let alertController = UIAlertController(title: "No Network", message: "No internet connection found. Please try again later.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
}

