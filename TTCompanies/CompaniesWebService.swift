//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation

class CompaniesWebService {
    private let stringURL = "http://megakohz.bget.ru/test.php"
    private let urlSession = URLSession.shared
    
    func getCompanies(completion: @escaping(_ companyDict: [[String: Any]]?, _ error: Error?) -> ()) {
        self.makeRequest(URL(string: stringURL)!, completion: completion)
    }
    
    func getCompanyDescription(companyId: String, completion: @escaping(_ companyDict: [[String: Any]]?, _ error: Error?) -> ()) {
        let strUrl = stringURL + "?id=\(companyId)"
        guard let url = URL(string: strUrl) else {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(nil, error)
            return
        }
        self.makeRequest(url, completion: completion)
    }
    
    private func makeRequest(_ URL: URL, completion: @escaping(_ companyDict: [[String: Any]]?, _ error: Error?) -> ()) {
        urlSession.dataTask(with: URL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let backToString = String(data: data, encoding: String.Encoding.utf8)
                let okJsonString  = backToString!.replacingOccurrences(of: #"(?<= )\"|\"(?= )"#, with: "'", options: .regularExpression)
                let jsonObject = try JSONSerialization.jsonObject(with: Data(okJsonString.utf8))
                guard let jsonDictionary = jsonObject as? [[String: Any]] else {
                    throw NSError(domain: "", code: -1, userInfo: nil)
                }
                completion(jsonDictionary, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
