// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import Overture

struct Client<Content: MusicArchive.Content> {
    var page: Int = 1

    var data: (URLRequest, _ completion: @escaping (Result<Data, Error>) -> Void) -> Void = { request, completion in
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data != nil ? .success(data!) : .failure(error!))
        }.resume()
    }

    func fetch(completion: @escaping (Result<[Content], Error>) -> Void) {
        data(urlRequest) { result in
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            case let .success(data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601())
                do {
                    let content = try decoder.decode([Content].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(content))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

extension Client {
    var urlRequest: URLRequest {
        update(URLRequest(url: url(Content.urlPath, page: page)), jsonRequest)
    }
}

private let jsonRequest: (inout URLRequest) -> Void = { request in
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
}

private let endpoint = "https://www.my-music-archive.com"

private func url(_ route: String, page: Int = 1) -> URL {
    URL(string: "\(endpoint)/\(route)?page=\(page)")!
}

private func urlRequest(_ route: String, page: Int = 1) -> URLRequest {
    .init(url: url(route, page: page))
}
