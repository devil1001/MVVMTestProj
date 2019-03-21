//
//  LoadingIndicator.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 22/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLoadingIndicator(on effectView: UIVisualEffectView) {
        effectView.removeFromSuperview()
        effectView.frame = CGRect(x: view.frame.midX - 24, y: view.frame.midY - 24, width: 48, height: 48)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        view.addSubview(effectView)
    }
}
