//
//  ApiConfig.swift
//  stockMarket
//
//  Created by Денис Кононов on 27.07.2024.
//

import Foundation

class APIConfig {
    static let shared = APIConfig()
    let apiKey: String

    private init() {
        self.apiKey = "l66zrTGImfy8pVEuQVrNHc1dySLBamkH"
       // self.apiKey = "RdWRaDUMdUkjzpiQC3byhmRFuzkrEmyf"
    }
}
