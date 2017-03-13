//
//  GradientLayer.swift
//  Demo
//
//  Created by Laura on 9/17/16.
//  Copyright © 2016 Laura. All rights reserved.
//

import UIKit

extension CAGradientLayer
{
    func createGradientColor() -> CAGradientLayer
    {
        let buttomColor = UIColor(colorLiteralRed: 29/255, green: 231/255, blue: 249/255, alpha: 1)
        let topColor = UIColor(colorLiteralRed: 84/255, green: 236/255, blue: 249/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocation: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocation as [NSNumber]?
        
        return gradientLayer
    }
}
