//
//  DashedBorderView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 21/05/2026.
//

import UIKit

@IBDesignable
class DashedBorderView: UIView {
    private var dashedLayer: CAShapeLayer!
    
    @IBInspectable var cornerRadius: CGFloat = 12.0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    @IBInspectable var dashColor: UIColor = .darkGray
    @IBInspectable var dashWidth: CGFloat = 1.0
    @IBInspectable var dashLength: NSNumber = 6
    @IBInspectable var dashGap: NSNumber = 4
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedLayer?.removeFromSuperlayer()
        dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = dashColor.cgColor
        dashedLayer.fillColor = nil
        dashedLayer.lineDashPattern = [dashLength, dashGap]
        dashedLayer.lineWidth = dashWidth
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        dashedLayer.path = path.cgPath
        
        layer.addSublayer(dashedLayer)
        layer.cornerRadius = cornerRadius
    }
}
