//
//  APDataManager.swift
//  anyplace
//
//  Created by Arpit Agarwal on 07/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//
import Foundation

protocol APDataManagerDelegate: class {
    func dataManagerLoadSuccessful(hotels: Hotels)
    func dataManagerLoadFailed()
}

class APDataManager {

    //delegate
    weak var delegate: APDataManagerDelegate?

    //init
    init(localJsonNamed: String) {
        if let path = Bundle.main.path(forResource: localJsonNamed, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) as Data
                let hotels: Hotels = try JSONDecoder().decode(Hotels.self, from: jsonData)
                
                delegate?.dataManagerLoadSuccessful(hotels: hotels)
                
            } catch let error {
                print("[Critical Error] Local JSON Load Failed: \(error)")
                
                delegate?.dataManagerLoadFailed()
            }
        }
    }
}
