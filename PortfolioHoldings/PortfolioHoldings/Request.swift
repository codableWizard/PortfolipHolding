import Foundation


class FetchHoldingsAPI : Codable {
    
    private func getUrlString() -> String {
        return "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    }

    
    func getResults(completionHandler: @escaping (HoldingsResponse?, Error?) -> Swift.Void) {
        let urlString = getUrlString()
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = Constants.ConstantStrings.Get
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FetchResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response.data, error)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        })
        
        task.resume()
    }
}



