//
//  APDataManager.swift
//  anyplace
//
//  Created by Arpit Agarwal on 07/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//
import Foundation

class APDataManager {

    //properties
    private var localJsonName: String
    public private(set) var hotels: Hotels = []

    //init
    init(localJsonNamed: String) {
        self.localJsonName = localJsonNamed
        self.loadData()
    }
    
    //load data
    func loadData() {
        if let path = Bundle.main.path(forResource: localJsonName, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) as Data
                hotels = try JSONDecoder().decode(Hotels.self, from: jsonData)
                
            } catch let error {
                print("[Critical Error] Local JSON Load Failed: \(error)")
            }
        }
    }
}
