//
//  AddressView.swift
//  lightinnout
//
//  Created by Gabriel Araujo on 22/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import UIKit
import TextFieldEffects

protocol AddressViewDelegate : class {
    func dismiss(text:String?)
}

class AddressView: UIView {
    
    var delegate:AddressViewDelegate?

    //Outlet var
    var view:UIView?
    @IBOutlet weak var txt: KaedeTextField!
    
    var presented = false

    
    //Init
    override init (frame : CGRect) {
        super.init(frame : frame)
        xibSetup()
    }
    convenience init () {
        self.init(frame:CGRect.zero)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    //Helper - Init
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view!.frame = bounds
        
        // Make the view stretch with containing view
        view!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view!)
        
        if let address = UD.string(forKey: kAddress) {
            self.txt.text = address
        }
    }
}

extension AddressView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.dismiss(text: textField.text)
        return true
    }
}
