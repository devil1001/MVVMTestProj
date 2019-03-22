//
//  CurrencyDTO.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 22/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation
import ObjectMapper

struct CurrencyDTO {
    var name: String?
}

extension CurrencyDTO: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
}
