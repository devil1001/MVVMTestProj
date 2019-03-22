//
//  CountryDetailsViewController.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 22/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CountryDetailsViewController: UIViewController, ErrorDialogPresenter {
    
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var bordersLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var viewModel: CountryDetailsViewModel?
    var updateCountries = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel?.getCountryDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateCountries.onCompleted()
        super.viewWillDisappear(animated)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        title = viewModel.countryName
        bind(label: capitalLabel, to: viewModel.capital)
        bind(label: populationLabel, to: viewModel.population)
        bind(label: bordersLabel, to: viewModel.borders)
        bind(label: currencyLabel, to: viewModel.currencies)
        
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel
            .onNavigateBack
            .subscribe(
                onNext: { [weak self] in
                    self?.updateCountries.onNext(())
                    let _ = self?.navigationController?.popViewController(animated: true)
                }
            ).disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.presentErrorDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setLoadingHud(visible: Bool) {
        if visible {
            showLoadingIndicator(on: effectView)
        } else {
            effectView.removeFromSuperview()
        }
    }
    
    private func bind(label: UILabel, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .map({
                label.isHidden = $0.isEmpty
                return $0
            })
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}
