//
//  CountryMapper.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation

final class CountryMapper {
    static func map(from dto: CountryDTO) -> Country {
        return Country(name: dto.name ?? "",
                       capital: dto.capital ?? "",
                       population: dto.population ?? 0,
                       borders: dto.borders,
                       cioc: dto.cioc,
                       currencies: dto.currencies.map { CurrencyMapper.map(with: $0) })
    }
}
