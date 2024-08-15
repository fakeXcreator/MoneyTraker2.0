//
//  TrackExpensesApp.swift
//  TrackExpenses
//
//  Created by Daniil Kim on 12.08.2024.
//

import SwiftUI

@main
struct TrackExpensesApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
