//
//  ContentView.swift
//  TrackExpenses
//
//  Created by Daniil Kim on 12.08.2024.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    
    @EnvironmentObject var transactionListVM: TransactionListViewModel
        
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 24){
                    // MARK:  Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    // MARK:  LineChart
                    let data = transactionListVM.accumulateTransactions()
                    
                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0
                        
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                                LineChart()
                            }
                            .background(Color.SystemBackground)
                        }
                            .data(data)
                            .chartStyle(ChartStyle(backgroundColor: .SystemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                            .frame(height: 300)
                    }
                    
                    // MARK:  Recent Transactions
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                // MARK:  Notification icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View {
        ContentView()
            .environmentObject(transactionListVM)
    }
}

