//
//  RecipeView.swift
//  FetchiOSChallenge
//
//  Created by Jules on 5/6/23.
//

import SwiftUI

let MEAL_BASE_URL = "https://themealdb.com/api/json/v1/1/lookup.php?i="

struct RecipeDetailView: View {
    let mealId: String
    let mealName: String
    @State private var recipe: Recipe?
    @State private var recipeImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let recipe = recipe {
                    VStack(alignment: .center) {
                        Image(uiImage: recipeImage ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200, alignment: .center)
                        if let value = recipe.strArea {
                            Text("\(value) recipe" ).italic()
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instructions").font(.headline)
                        Text(recipe.strInstructions)
                        Text("Ingredients").font(.headline)
                        ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                            if ingredient != "" {
                                Text("- \(ingredient): \(recipe.measures[index])")
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .onAppear(perform: getRecipe)
            .navigationBarTitle(mealName, displayMode: .inline) // The inline display mode is to avoid any truncated titles
        }.refreshable { // In case something go wrong when loading the first time
            getRecipe()
        }
    }

    func getRecipe() {
        if let url = URL(string: "\(MEAL_BASE_URL+mealId)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let recipeJson = try JSONDecoder().decode(RecipeDetail.self, from: data)
                        self.recipe = recipeJson.meals.first
                        getImage()
                    } catch {
                        print("Error fetching the recipe details")
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func getImage() {
        guard let url = URL(string: recipe?.strMealThumb ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching recipe image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.recipeImage = UIImage(data: data)
            }
        }.resume()
    }
}

struct RecipeDetail: Codable {
    let meals: [Recipe]
}
