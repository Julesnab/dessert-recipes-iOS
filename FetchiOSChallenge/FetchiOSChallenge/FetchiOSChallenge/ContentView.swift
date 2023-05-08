//
//  ContentView.swift
//  FetchiOSChallenge
//
//  Created by Jules on 5/6/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DessertViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.desserts, id: \.idMeal) { dessert in
                NavigationLink(destination: RecipeDetailView(mealId: dessert.idMeal, mealName: dessert.strMeal)) {
                    Text(dessert.strMeal)
                }
            }.navigationTitle("Dessert Recipes")
        }.refreshable { // In case something go wrong when loading the first time
            viewModel.getDesserts()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
