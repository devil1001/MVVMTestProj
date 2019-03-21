//
//  CountriesTableViewModel.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum CountryCellType {
    case normal(cellViewModel: CountryCellViewModel)
    case error(message: String)
    case empty
}

final class CountriesTableViewModel {
    var countryCells: Observable<[CountryCellType]> {
        return cells.asObservable()
    }
    
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    let onShowError = PublishSubject<ErrorAlert>()
    let countriesRepo: CountriesRepository
    let disposeBag = DisposeBag()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[CountryCellType]>(value: [])
    
    init(countriesRepo: CountriesRepository = CountriesRepository()) {
        self.countriesRepo = countriesRepo
    }
    
    func getCountries() {
        loadInProgress.accept(true)
        
        countriesRepo
            .getCountries()
            .subscribe(
                onNext: { [weak self] countries in
                    self?.loadInProgress.accept(false)
                    guard countries.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }
                    
                    self?.cells.accept(countries.compactMap {
                        .normal(cellViewModel: CountryCellViewModel(country: $0 ))
                    })
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.cells.accept([.error(message: "Loading failed, check network connection")])
                }
            )
            .disposed(by: disposeBag)
    }
}
