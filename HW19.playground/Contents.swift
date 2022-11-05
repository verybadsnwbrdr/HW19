import UIKit
import CryptoKit

extension String {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}

struct MarvelURL {
    private var components = URLComponents()
    
    private let scheme = "http"
    private let host = "gateway.marvel.com"
    private let path = "/v1/public/comics/18474"

    private let ts = "hw19"
    private let publicKey = "ca67588a7b5d724d5f0da0314d1e34a8"
    private let privateKey = "5c8b05e986cb96534bb107c990e494e1982bc42d"
    
    private var hash: String {
        (ts + privateKey + publicKey).md5()
    }
    
    init() {
        set()
    }
    
    private mutating func set() {
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "ts", value: ts),
                                 URLQueryItem(name: "apikey", value: publicKey),
                                 URLQueryItem(name: "hash", value: hash)]
    }
    
    public func getStringUrl() -> String {
        components.string ?? "Error"
    }
}

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let response = response as? HTTPURLResponse else {
            print("Проблемы с сетью")
            return
        }
        switch response.statusCode {
        case 200:
            guard let data = data,
                  let dataAsString = String(data: data, encoding: .utf8) else { return }
            print("Responce status code - 200 \n\(dataAsString)")
        default:
            if let error = error {
                print("Ошибка \(error.localizedDescription)")
            } else {
                print("Статус кода запроса - \(response.statusCode)")
            }
        }
    }.resume()
}

// MARK: - Task 1

let url = "https://api.open-meteo.com/v1/forecast?latitude=55.7558&longitude=37.6176&hourly=temperature_2m&current_weather=true"
//getData(urlRequest: url)

// MARK: - Task 2

let marvelURL = MarvelURL()
getData(urlRequest: marvelURL.getStringUrl())
