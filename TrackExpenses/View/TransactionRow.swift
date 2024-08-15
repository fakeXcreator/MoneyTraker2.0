//
//  TransactionRow.swift
//  TrackExpenses
//
//  Created by Daniil Kim on 13.08.2024.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    @EnvironmentObject var viewModel: TransactionListViewModel
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            
            // MARK:  Automatic icons is insane
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    let icon = viewModel.icon(for: transaction)
                    FontIcon.text(.awesome5Solid(code: icon), fontsize: 24, color: Color.icon)
                }
            
            VStack(alignment: .leading, spacing: 6){
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                Text(viewModel.dateParsed(for: transaction), format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(viewModel.signedAmount(for: transaction), format: .currency(code: "USD"))
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.text : .primary)
        }
        .padding([.top, .bottom], 9)
    }
}

#Preview {
    TransactionRow(transaction: transactionPreviewData)
        .environmentObject(TransactionListViewModel())
}
