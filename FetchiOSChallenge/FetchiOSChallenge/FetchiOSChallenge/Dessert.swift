//
//  Dessert.swift
//  FetchiOSChallenge
//
//  Created by Jules on 5/6/23.
//

import Foundation

struct Dessert: Comparable, Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    // Necessary to compare the desserts name to sort them (they are already sorted before adding this function but this makes it more reliable)
    static func < (d1: Dessert, d2: Dessert) -> Bool {
        d1.strMeal < d2.strMeal
    }
}
