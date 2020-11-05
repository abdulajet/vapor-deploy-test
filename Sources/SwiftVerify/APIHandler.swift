import NIO
import Foundation

struct APIHandler {
    
    enum APIHandlerError: Error {
        case data
        case decode
    }
    
    func sendRequest<T: Codable>(host: String, path: String, body: T?, eventLoop: EventLoop) -> EventLoopFuture<String> {
        let promise = eventLoop.makePromise(of: String.self)
        
        URLSession.shared.dataTask(with: buildRequest(host: host, path: path, body: body)) { data, response, error in
            if let error = error {
                promise.fail(error)
                return
            }
            
            guard let data = data else {
                promise.fail(APIHandlerError.data)
                return
            }
            
            guard let resString = String(data: data, encoding: .utf8) else {
                promise.fail(APIHandlerError.decode)
                return
            }
            
            promise.succeed(resString)
            
        }.resume()
        
        return promise.futureResult
    }
    
    private func buildRequest<T: Codable>(host: String, path: String, body: T?) -> URLRequest {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        var request: URLRequest!
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        request = URLRequest(url: urlComponents.url!)
        request.httpBody = try? jsonEncoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "post"
        
        return request
    }
}
