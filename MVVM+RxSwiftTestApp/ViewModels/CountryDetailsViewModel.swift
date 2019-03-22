//
//  CountryDetailsViewModel.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 22/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import RxSwift
import RxCocoa

final class CountryDetailsViewModel {
    let onNavigateBack = PublishSubject<Void>()
    let onShowError = PublishSubject<ErrorAlert>()
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    var capital = BehaviorRelay<String>(value: "")
    var population = BehaviorRelay<String>(value: "")
    var borders = BehaviorRelay<String>(value: "")
    
    private let loadInProgress = BehaviorRelay<Bool>(value: false)
    let countriesRepo: CountriesRepository
    let countryName: String
    private let disposeBag = DisposeBag()
    
    init(countryName: String, countriesRepo: CountriesRepository) {
        self.countriesRepo = countriesRepo
        self.countryName = countryName
    }
    
    func getCountryDetails() {
        loadInProgress.accept(true)
        countriesRepo.getDetails(for: countryName)
            .subscribe(
                onNext: { [weak self] country in
                    self?.loadInProgress.accept(false)
                    self?.capital.accept("Capital: \(country.capital)")
                    self?.population.accept("Population: \(country.population.description)")
                    var resultBorders: String
                    if country.borders.isEmpty {
                        resultBorders = "Country hasn't borders with another countries"
                    } else {
                        resultBorders = "Borders: "
                        for border in country.borders {
                            resultBorders += "\(self?.countriesRepo.getCountryName(by: border) ?? ""), "
                        }
                        resultBorders = String(resultBorders.dropLast(2))
                    }
                    
                    self?.borders.accept(resultBorders)
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    
                    let okAlert = ErrorAlert(title: "Could not connect to server.",
                                             message: "Check your network and try again later.",
                                             action: AlertAction(buttonTitle: "OK", handler: nil))
                    self?.onShowError.onNext(okAlert)
                }
            )
            .disposed(by: disposeBag)
    }
}
