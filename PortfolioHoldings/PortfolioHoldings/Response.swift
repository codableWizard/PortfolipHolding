import Foundation



class FetchResponse : Codable {
    var data : HoldingsResponse?
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(HoldingsResponse.self, forKey: .data)

    }

}

class HoldingsResponse : Codable {
    var userHolding : [HoldingModel]?
    
    private enum CodingKeys : String, CodingKey {
        case userHolding
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userHolding, forKey: .userHolding)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userHolding = try values.decodeIfPresent([HoldingModel].self, forKey: .userHolding)

    }

}
