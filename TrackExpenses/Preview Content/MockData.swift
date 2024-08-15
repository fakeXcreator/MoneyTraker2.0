//
//  MockData.swift
//  TrackExpenses
//
//  Created by Daniil Kim on 13.08.2024.
//

import Foundation

var transactionPreviewData = Transaction(id: 1, date: "01/01/2024", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple", amount: 100, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
