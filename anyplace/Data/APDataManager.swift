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

    //properties
    private var localJsonName: String
    public private(set) var hotels: Hotels = []
    weak var delegate: APDataManagerDelegate?

    //init
    init(localJsonNamed: String) {
        self.localJsonName = localJsonNamed
    }
    
    //load data
    func loadData() {
        if let path = Bundle.main.path(forResource: localJsonName, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) as Data
                hotels = try JSONDecoder().decode(Hotels.self, from: jsonData)
                
                delegate?.dataManagerLoadSuccessful(hotels: hotels)
                
            } catch let error {
                print("[Critical Error] Local JSON Load Failed: \(error)")
                
                delegate?.dataManagerLoadFailed()
            }
        }
    }
}
