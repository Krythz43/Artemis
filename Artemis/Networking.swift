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

enum APICalls {
    case everything
    case geoSearch
    case topHeadlines
    case categoricalSearch
}

enum categories{
    case business
    case sports
    case technology
    case entertainment
    case health
    case science
    case general
    case undefined
}

func getCategory(_ category : categories) -> String {
   
    switch category {
        case .business : return "business"
        case .sports : return "sports"
        case .technology : return "technology"
        case .entertainment : return "entertainment"
        case .health : return "health"
        case .science : return "science"
        case .general : return "general"
        case .undefined : return ""
        default: return ""
    }
}

struct Networking {
    static let sharedInstance = Networking()
    let session = URLSession.shared
    
    
    func getURL (_ callType: APICalls,_ category : categories = categories.undefined) -> String {
        
        let languageSetting = "en"
        let querySearchParams = ""
        let from = getDateAndTimeInISO(year: 0,month: 0,date: 0,hours: 0,min : 0, sec: 0)
        let to = getDateAndTimeInISO(year: 0,month: 0,date: 0,hours: 0,min : 0, sec: 0)
        
        switch callType {
            case .everything:
                return "https://newsapi.org/v2/top-headlines?language=" + languageSetting + "&apiKey=" + API_KEY
        case .categoricalSearch:
            print("Buisness raw value " , getCategory(.business))
            return "https://newsapi.org/v2/top-headlines?category=" + getCategory(category) + "&apiKey=" + API_KEY
        case .geoSearch:
                // phase 3
                return ""
        case .topHeadlines:
                // phase 1
                return ""
            default:
                print("Invalid call attempt")
                return ""
        }
    }
    
//https://newsapi.org/v2/top-headlines/sources?category=business&apiKey=db6fb73ef14a4f0eadf77a19254d9c3b
    
    func getNews(completion : @escaping (Result<News,UserError>) -> Void) {
        
        let queryURL = getURL(.categoricalSearch,.business)
        
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
                print("First article : ",userResponse.articles?[0])
                completion(.success(userResponse))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}

func getDateAndTimeInISO (year: Int,month: Int,date: Int,hours: Int,min : Int, sec: Int) -> Int{
    // place holder
    // Convert the given time and date details to ISO cause the API accepts the same
    return 0
}
