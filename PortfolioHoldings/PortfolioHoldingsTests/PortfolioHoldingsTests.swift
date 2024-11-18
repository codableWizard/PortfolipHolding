import XCTest
@testable import PortfolioHoldings

final class PortfolioHoldingsTests: XCTestCase {
    
    private var sut : ViewModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = ViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTask(){
       
        let model = HoldingModel(symbol: "MAHABANK", quantity: 990, ltp: 38.05, avgPrice: 35, close: 40)
        sut.updateHoldings(with: [model])
        let curValue : Double = 990.0 * 38.05
        let totalInv : Double = 990.0 * 35.0
        let totalPnl = curValue - totalInv
        let todaysPnL = (40.0 - 38.05) * 990.0
        
        XCTAssertEqual(sut.currentValue, curValue)
        XCTAssertEqual(sut.totalInvAmt, totalInv)
        XCTAssertEqual(sut.totalPnLAmt, totalPnl)
        XCTAssertEqual(sut.todaysPnLAmt, todaysPnL.roundTo(2))

        XCTAssertEqual(model.getTotalPnL(), totalPnl)
        XCTAssertFalse(model.isInLoss ?? false)
        XCTAssertEqual(model.getTotalPnL(), totalPnl)
        
        XCTAssertEqual("19.5", (19.5000).truncateZeros(digitsAfterDecimal: 2))
        XCTAssertEqual("\(Constants.ConstantStrings.RupeeSymbol)19,500.08", (19500.08).toCommaSeperatedAmount(digitsAfterDecimal: 2))
    }

    
    func test_checkAPI(){
       let request = FetchHoldingsAPI()
        let expectation = self.expectation(description: "ValidHoldingResponse")

        request.getResults { response, error in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
