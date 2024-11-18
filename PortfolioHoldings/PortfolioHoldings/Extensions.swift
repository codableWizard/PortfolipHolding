import Foundation

extension Double{
    func roundTo(_ digits: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
        if self.isNaN || self.isInfinite {
            return 0
        }
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded(rule) / multiplier
    }

    func truncateZeros(digitsAfterDecimal: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = digitsAfterDecimal
        return formatter.string(for: self)
    }
    
    public func toCommaSeperatedAmount(digitsAfterDecimal: Int? = nil) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_IN")
        if let _digitsAfterDecimal = digitsAfterDecimal  {
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = _digitsAfterDecimal
        }
        let sign = (self < 0) ? "-" : ""
        return "\(sign)\(Constants.ConstantStrings.RupeeSymbol)\(numberFormatter.string(from: NSNumber(value:abs(self))) ?? String(abs(self)))"
    }
    

}
