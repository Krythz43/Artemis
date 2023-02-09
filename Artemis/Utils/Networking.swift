//
//  Networking.swift
//  Artemis
//
//  Created by Krithick Santhosh on 12/01/23.
//

import Foundation

enum UserError :  Error {
    case invalidURL
    case noDataAvailable
    case canNotProcessData
}

struct Networking {
    static let sharedInstance = Networking()
    let session = URLSession.shared
    
    
    func getURL (_ callType: APICalls,_ category : categories = categories.undefined,_ query: String = "",_ countryCode: String = "",_ source: String = "",_ page: Int = 1) -> String {
        
        let languageSetting = "en"
        let from = getDateAndTimeInISO(year: 0,month: 0,date: 0,hours: 0,min : 0, sec: 0)
        let to = getDateAndTimeInISO(year: 0,month: 0,date: 0,hours: 0,min : 0, sec: 0)
        
        print("Handling a calll of type:",callType)
        
        var modifiedCallType = callType
        if(query == "" && source == "" && callType == .querySearch){
            modifiedCallType = .everything
        }
        
        switch modifiedCallType {
            case .everything:
                return "https://newsapi.org/v2/top-headlines?language=" + languageSetting + "&page=\(page)" + "&apiKey=" + API_KEY
            case .categoricalSearch:
                return "https://newsapi.org/v2/top-headlines?category=" + getCategory(category) + "&page=\(page)" + "&apiKey=" + API_KEY
            case .geoSearch:
                // phase 3
                return "https://newsapi.org/v2/top-headlines?country=" + countryCode + "&category=" + getCategory(category) + "&page=\(page)" + "&apiKey=" + API_KEY
            case .querySearch:
                return "https://newsapi.org/v2/top-headlines?q=" + query + "&sources=" + source + "&page=\(page)" + "&apiKey=" + API_KEY
        case .sourceSearch:
            "Sources Search call attempted"
            return "https://newsapi.org/v2/top-headlines?sources=" + source + "&language=" + languageSetting + "&page=\(page)" + "&apiKey=" + API_KEY
        case .sources:
            "Sources call attempted"
            return "https://newsapi.org/v2/top-headlines/sources?category=" + getCategory(category) + "&page=\(page)" + "&apiKey=" + API_KEY
        default:
                print("Invalid call attempt")
                return ""
        }
    }
    
//https://newsapi.org/v2/top-headlines/sources?category=business&apiKey=db6fb73ef14a4f0eadf77a19254d9c3b
    
    func getNews(type: APICalls, category: categories = .undefined, query : String = "", countryCode: String = "", source : String = "",page: Int = 1 ,completion : @escaping (Result<News,UserError>) -> Void) {
        
        let queryURL = getURL(type,category,query,countryCode,source,page)
        print("The recieved source is :",source," for URL: ",queryURL)
        guard let UserURL = URL(string: queryURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let dataTask = session.dataTask(with: UserURL){data,_,_ in
            print("URL used : ", queryURL)
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                print("The JSON has been recieved!",jsonData)
                let userResponse = try decoder.decode(News.self, from: jsonData)
                print("Articles returned by query : ",userResponse.articles?.count ?? 0)
//                print("First article : ",userResponse.articles?[0])
                completion(.success(userResponse))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    func getSources(type: APICalls, category: categories = .undefined, query : String = "", countryCode: String = "" ,completion : @escaping (Result<SourcesV2,UserError>) -> Void) {
        
        let queryURL = getURL(type,category,query,countryCode)
        
        guard let UserURL = URL(string: queryURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let dataTask = session.dataTask(with: UserURL){data,_,_ in
            print("URL used : ", queryURL)
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                print("The JSON has been recieved!",jsonData)
                let userResponse = try decoder.decode(SourcesV2.self, from: jsonData)
                print("Articles returned by query : ",userResponse)
//                print("First article : ",userResponse.articles?[0])
                completion(.success(userResponse))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}

fileprivate func getDateAndTimeInISO (year: Int,month: Int,date: Int,hours: Int,min : Int, sec: Int) -> Int{
    // place holder
    // Convert the given time and date details to ISO cause the API accepts the same
    return 0
}
