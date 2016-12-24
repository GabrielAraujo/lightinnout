//
//  TodayViewController.swift
//  Widget
//
//  Created by Gabriel Araujo on 23/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var imgViewButton: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    
    var tap:UITapGestureRecognizer!
    
    var bulbState:BulbState = .off {
        didSet {
            self.changeEnv()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if UD.bool(forKey: kBulbStateOn) {
            self.bulbState = .on
        }
        self.setupTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTap(){
        self.tap = UITapGestureRecognizer(target: self, action: #selector(TodayViewController.tapReceived(_:)))
        self.tap.numberOfTapsRequired = 1
        self.imgViewButton.addGestureRecognizer(self.tap)
    }
    
    func tapReceived(_ gesture: UITapGestureRecognizer){
        if bulbState == .on {
            BulbService.setOff(completion: {
                result in
                switch result {
                case .success( _):
                    self.bulbState = .off
                    UD.set(false, forKey: kBulbStateOn)
                    self.lblError.text = "Desligado!"
                case .failure(let error):
                    self.lblError.text = Errors.getMessage(error: error)
                }
            })
        }else{
            BulbService.setOn(completion: {
                result in
                switch result {
                case .success( _):
                    self.bulbState = .on
                    UD.set(true, forKey: kBulbStateOn)
                    self.lblError.text = "Ligado!"
                case .failure(let error):
                    self.lblError.text = Errors.getMessage(error: error)
                }
            })
        }
    }
    
    //Helper
    private func changeEnv(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                switch self.bulbState {
                case .on:
                    self.imgViewButton.image = UIImage(named: "bulbon")
                case .off:
                    self.imgViewButton.image = UIImage(named: "bulboff")
                }
            })
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
