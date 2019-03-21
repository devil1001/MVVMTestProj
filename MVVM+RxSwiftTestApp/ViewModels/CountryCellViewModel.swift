//
//  CountriesCellViewModel.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation

struct CountryCellViewModel {
    let name: String
    let population: Int
    
    init(country: Country) {
        name = country.name
        population = country.population
    }
}
