import Foundation

class HoldingModel : Codable {
    var symbol : String?
    var quantity : Int?
    var ltp : Double?
    var totalPnL : Double?
    var isInLoss : Bool?
    var avgPrice : Double?
    var close : Double?
    
    private enum CodingKeys : String, CodingKey {
        case symbol
        case quantity
        case ltp
        case avgPrice
        case close
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        ltp = try values.decodeIfPresent(Double.self, forKey: .ltp)
        avgPrice = try values.decodeIfPresent(Double.self, forKey: .avgPrice)
        close = try values.decodeIfPresent(Double.self, forKey: .close)

    }
    
    init(symbol: String?, quantity: Int?, ltp: Double?, avgPrice : Double?, close : Double?) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.avgPrice = avgPrice
        self.close = close
    }
    
    
    func getTotalPnL() -> Double {
        if let totalPnL = self.totalPnL {
            return totalPnL
        }
        
        var totalPL : Double = 0
        if let ltp = self.ltp, let qty = self.quantity, let avgPrice = self.avgPrice{
            let curValue : Double = ltp * Double(qty)
            let totalInv = avgPrice * Double(qty)
            totalPL = curValue - totalInv
            self.totalPnL = totalPL.roundTo(2)
            if curValue < totalInv {
                self.isInLoss = true
            }
        }
        return totalPL.roundTo(2)
    }

}
