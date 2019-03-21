//
//  CountriesRepository.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Moya_ObjectMapper

fileprivate enum CountriesAPI {
    case CountriesQuery
}

final class CountriesRepository {
    fileprivate let provider = MoyaProvider<CountriesQuery>()
    fileprivate let apiType: CountriesAPI = .CountriesQuery
    
    func getCountries() -> Observable<[Country]> {
        return provider
            .rx
            .request(.all)
            .mapArray(CountryDTO.self)
            .asObservable()
            .map { countries in
                return countries.map { CountryMapper.map(from: $0) }
        }
    }
}
