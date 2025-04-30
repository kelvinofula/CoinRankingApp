//
//  UIViewExt.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit

var spinner: MaterialSpinner?

extension UIView {
    
    // MARK: - Material Design ProgressBar
    func showProgressBar(padding: Double? = 0.0, color: UIColor? = UIColor.black) {
        isHidden = false
        spinner = MaterialSpinner(frame: CGRect(x: 0, y: 0, width: frame.width - padding!, height: frame.height - padding!), strokeColor: color!)
        addSubview(spinner!)
    }
    
    func stopProgressBar() {
        isHidden = true
        spinner?.removeFromSuperview()
    }
    
}
