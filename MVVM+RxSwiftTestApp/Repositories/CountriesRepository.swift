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
    private let provider = MoyaProvider<CountriesQuery>()
    private let apiType: CountriesAPI = .CountriesQuery
    private var cachedCountries: [Country] = []
    
    func getCountries() -> Observable<[Country]> {
        return provider
            .rx
            .request(.all)
            .mapArray(CountryDTO.self)
            .asObservable()
            .map { [weak self] countriesDTO in
                let countries = countriesDTO.map { CountryMapper.map(from: $0) }
                self?.cachedCountries = countries
                return countries
        }
    }
    
    func getDetails(for countryName: String) -> Observable<Country> {
        return provider
            .rx
            .request(.name(countryName: countryName))
            .mapArray(CountryDTO.self)
            .asObservable()
            .map { countries in
                return CountryMapper.map(from: countries.first(where: { $0.name == countryName }) ?? CountryDTO())
        }
    }
    
    func getCountryName(by cioc: String) -> String {
        return cachedCountries.first(where: { $0.cioc == cioc })?.name ?? cioc
    }
}
