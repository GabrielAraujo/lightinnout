//
//  ViewController.swift
//  lightinnout
//
//  Created by Gabriel Araujo on 21/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Spring
import SCLAlertView

class ViewController: UIViewController {

    @IBOutlet weak var btnBulb: UIButton!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var springContainer: SpringView!
    @IBOutlet weak var viewAddress: AddressView! {
        didSet {
            viewAddress.delegate = self
        }
    }
    
    var bulbState:BulbState = .off {
        didSet {
            self.changeEnv()
        }
    }
    
    var swipeDown:UISwipeGestureRecognizer!
    var swipeUp:UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UD.bool(forKey: kBulbStateOn) {
            self.bulbState = .on
        }
        self.setupSwipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Helper
    private func changeEnv(){
        switch self.bulbState {
        case .on:
            self.view.backgroundColor = UIColor.white
            self.indicator.color = UIColor.white
            self.btnBulb.setImage(UIImage(named: "bulbon"), for: .normal)
        case .off:
            self.view.backgroundColor = UIColor.black
            self.indicator.color = UIColor.black
            self.btnBulb.setImage(UIImage(named: "bulboff"), for: .normal)
        }
    }
    
    func setupSwipe(){
        self.swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeReceived(_:)))
        self.swipeDown.direction = .down
        self.swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeReceived(_:)))
        self.swipeUp.direction = .up
        self.btnBulb.addGestureRecognizer(swipeUp)
        self.btnBulb.addGestureRecognizer(swipeDown)
        //self.view.addGestureRecognizer(swipeDown)
    }
    
    func swipeReceived(_ gesture: UIGestureRecognizer){
        if let swipe = gesture as? UISwipeGestureRecognizer {
            if swipe.direction == .down {
                if !self.viewAddress.presented {
                    self.showAddressView()
                }
            }else {
                if self.viewAddress.presented {
                    self.dismissAddressView()
                }
            }
        }
    }
    
    fileprivate func dismissAddressView(){
        springContainer.force = 1
        springContainer.duration = 1
        springContainer.delay = 0
        
        springContainer.damping = 0.7
        springContainer.velocity = 0.7
        springContainer.scaleX = 1
        springContainer.scaleY = 1
        springContainer.x = 0
        springContainer.y = 0
        springContainer.rotate = 0
        
        springContainer.animation = Spring.AnimationPreset.ZoomOut.rawValue
        
        springContainer.animate()
        
        self.viewAddress.presented = false
    }
    
    fileprivate func showAddressView(){
        springContainer.isHidden = false
        springContainer.force = 1
        springContainer.duration = 1
        springContainer.delay = 0
        
        springContainer.damping = 0.7
        springContainer.velocity = 0.7
        springContainer.scaleX = 1
        springContainer.scaleY = 1
        springContainer.x = 0
        springContainer.y = 0
        springContainer.rotate = 0
        
        springContainer.animation = Spring.AnimationPreset.SlideDown.rawValue
        
        springContainer.animate()
        
        self.viewAddress.presented = true
    }
    
    fileprivate func showErrorAlert(message:String){
        SCLAlertView().showError("Erro", subTitle: message)
    }
    
    @IBAction func btnBulbTapped(_ sender: UIButton) {
        if bulbState == .on {
            self.indicator.startAnimating()
            BulbService.setOff(completion: {
                result in
                self.indicator.stopAnimating()
                switch result {
                case .success( _):
                    self.bulbState = .off
                    UD.set(false, forKey: kBulbStateOn)
                case .failure(let error):
                    self.showErrorAlert(message: Errors.getMessage(error: error))
                }
            })
        }else{
            self.indicator.startAnimating()
            BulbService.setOn(completion: {
                result in
                self.indicator.stopAnimating()
                switch result {
                case .success( _):
                    self.bulbState = .on
                    UD.set(true, forKey: kBulbStateOn)
                case .failure(let error):
                    self.showErrorAlert(message: Errors.getMessage(error: error))
                }
            })
        }
    }
}

extension ViewController : AddressViewDelegate {
    func dismiss(text:String?) {
        if let txt = text {
            if txt.isEmpty {
                if UD.string(forKey: kAddress) == nil {
                    self.showErrorAlert(message: Errors.getMessage(error: Errors.defineAddress))
                }
            }else{
                UD.set(txt, forKey: kAddress)
                SCLAlertView().showNotice("Pronto", subTitle: "Endereço salvo!")
                self.dismissAddressView()
            }
        }else{
            if UD.string(forKey: kAddress) == nil {
                self.showErrorAlert(message: Errors.getMessage(error: Errors.defineAddress))
                
            }
        }
        self.view.endEditing(true)
    }
}

