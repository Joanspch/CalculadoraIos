//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Joan Paredes on 10/10/20.
//

import UIKit
    private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton{
    
    //Borde Redondo
    
    func round() {
        layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
    
    //Brillo al tocar
    
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
                        self.alpha = 0.5
        }) {(completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    //cambio de color de botones
    func selectOperation(_ selected: Bool){
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }
}
