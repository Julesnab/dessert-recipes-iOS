//
//  DessertView.swift
//  FetchiOSChallenge
//
//  Created by Jules on 5/6/23.
//

import Foundation

let DESSERT_URL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"

class DessertViewModel: ObservableObject {
    @Published var desserts = [Dessert]()

    init() {
        getDesserts()
    }

    func getDesserts() {
        if let url = URL(string: DESSERT_URL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let dessertJson = try JSONDecoder().decode(DessertList.self, from: data)
                        DispatchQueue.main.async {
                            self.desserts = dessertJson.meals.filter { $0.strMeal != ""}
                            self.desserts.sort()
                        }
                    } catch {
                        print("Error fetching the desserts' list")
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

struct DessertList: Codable {
    let meals: [Dessert]
}
