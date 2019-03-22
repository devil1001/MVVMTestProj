//
//  CurrencyMapper.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 22/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import Foundation

final class CurrencyMapper {
    static func map(with dto: CurrencyDTO) -> Currency {
        return Currency(name: dto.name ?? "")
    }
}
