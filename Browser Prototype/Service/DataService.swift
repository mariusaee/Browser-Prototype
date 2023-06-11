//
//  DataService.swift
//  Browser Prototype
//
//  Created by Marius Malyshev on 11.06.2023.
//

import Foundation

class DataService {
    static let shared = DataService()
    private init() {}
    
    private let defaults = UserDefaults.standard

    func saveHistory(_ history: [String]) {
        defaults.set(history, forKey: Constants.Keys.userDefaultsHistoryKey)
    }
    
    func loadHistory() -> [String] {
        return defaults.stringArray(forKey: Constants.Keys.userDefaultsHistoryKey) ?? []
    }
}
