//
//  CountryDTO.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation
import ObjectMapper

struct CountryDTO {
    var name: String?
    var capital: String?
    var population: Int?
    var borders: [String] = []
    var cioc: String?
}

extension CountryDTO: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        capital <- map["capital"]
        population <- map["population"]
        borders <- map["borders"]
        cioc <- map["cioc"]
    }
}
