import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
}
