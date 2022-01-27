//
//  String.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import Foundation

extension String {
    func isContainEqual(_ value: String) -> String? {
        return self.lowercased()
            .components(separatedBy: " ")
            .first(where: {
                String($0.prefix(value.count)) == value
            })
    }
}
