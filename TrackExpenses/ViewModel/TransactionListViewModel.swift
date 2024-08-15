import Foundation
import Combine
import SwiftUIFontIcon
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    // Must be real API
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching transaction:", error.localizedDescription)
                case .finished:
                    print("Finished fetching transactions")
                }
            } receiveValue: { [weak self] result in
                self?.transactions = result
            }
            .store(in: &cancellables)
    }
    
    func icon(for transaction: Transaction) -> FontAwesomeCode {
        if let category = Category.all.first(where: { $0.id == transaction.categoryId }) {
            return category.icon
        }
        return .question
    }
    
    func dateParsed(for transaction: Transaction) -> Date {
        return transaction.date.dateParsed()
    }
    
    func signedAmount(for transaction: Transaction) -> Double {
        return transaction.type == TransactionType.credit.rawValue ? transaction.amount : -transaction.amount
    }
    
    func month(for transaction: Transaction) -> String {
        let date = dateParsed(for: transaction)
        return date.formatted(.dateTime.year().month(.wide))
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { transaction in
            return self.month(for: transaction)
        }
        
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }
        
        let today = "02/12/2022".dateParsed()
        guard let dateInterval = Calendar.current.dateInterval(of: .month, for: today) else {
            return []
        }
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        // Iterating through each day in the interval
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            // Simplified date comparison by stripping time components
            let dailyExpenses = transactions.filter {
                Calendar.current.isDate($0.date.dateParsed(), inSameDayAs: date) && $0.isExpense
            }
            
            let dailyTotal = dailyExpenses.reduce(0) { $0 - signedAmount(for: $1) }
            
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
        }
        return cumulativeSum
    }
}
