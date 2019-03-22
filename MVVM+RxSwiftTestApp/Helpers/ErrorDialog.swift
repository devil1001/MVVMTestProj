//
//  ErrorDialog.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct ErrorAlert {
    let title: String
    let message: String?
    let action: AlertAction?
}

protocol ErrorDialogPresenter {
    func presentErrorDialog(alert: ErrorAlert)
}

extension ErrorDialogPresenter where Self: UIViewController {
    func presentErrorDialog(alert: ErrorAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action?.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action?.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}
