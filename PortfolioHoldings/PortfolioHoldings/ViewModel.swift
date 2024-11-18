import Foundation


protocol HoldingsVMProtocol : AnyObject{
    func fetchedHoldingsUpdateUI()
    func errorInAPI()
}

class ViewModel : NSObject {
    var userHolding : [HoldingModel]?
    weak var delegate : HoldingsVMProtocol?
    var currentValue : Double = 0
    var totalInvAmt : Double = 0
    var todaysPnLAmt : Double = 0
    var totalPnLAmt : Double = 0
    
    
    func fetchHoldings() {
        FetchHoldingsAPI().getResults {[weak self] response, error in
            if let holdingResponse = response, let holdings = holdingResponse.userHolding, holdings.count > 0 {
                self?.updateHoldings(with: holdings)
            }else{
                self?.delegate?.errorInAPI()
            }
        }
    }
    
    
    func updateHoldings(with holdings : [HoldingModel]){
        self.userHolding = holdings
        updateData(with: holdings)
    }
    
    private func updateData(with holdings : [HoldingModel]){
        //userHolding = holdings
        currentValue = getCurrentValue()
        totalInvAmt = getTotalInvestment()
        todaysPnLAmt = getTodaysPnLAmt()
        totalPnLAmt = getTotalPnLAmt()
        delegate?.fetchedHoldingsUpdateUI()
    }
    
    private func getCurrentValue() -> Double {
        var curValue : Double = 0
        if let userHolding = userHolding{
            for holding in userHolding{
                if let qty = holding.quantity, let ltp = holding.ltp{
                    curValue += Double(qty) * ltp
                }
            }
        }
        return curValue.roundTo(2)
    }
    
    private func getTotalInvestment() -> Double {
        var totalInv : Double = 0
        if let userHolding = userHolding{
            for holding in userHolding{
                if let qty = holding.quantity, let avgPrice = holding.avgPrice{
                    totalInv += Double(qty) * avgPrice
                }
            }
        }
        return totalInv.roundTo(2)
    }
    
    private func getTotalPnLAmt() -> Double {
        var totalPnL : Double = 0
        totalPnL = currentValue - totalInvAmt
        return totalPnL.roundTo(2)
        
    }
    
    private func getTodaysPnLAmt() -> Double {
        var todaysPnL : Double = 0
        if let userHolding = userHolding{
            for holding in userHolding{
                if let qty = holding.quantity, let close = holding.close, let ltp = holding.ltp{
                    todaysPnL += (close - ltp) * Double(qty)
                }
            }
        }
        return todaysPnL.roundTo(2)
    }
    
}

extension ViewModel{
    
    func getRowsCount() -> Int{
        if let holdings = userHolding{
            return holdings.count
        }
        return 0
    }
    
    func getCellModel(for row : Int) -> HoldingModel? {
        if let holdings = userHolding, holdings.count > 0, row < holdings.count {
            return holdings[row]
        }
        return nil
    }
    
    
}
