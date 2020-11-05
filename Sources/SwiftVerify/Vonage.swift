import NIO
import Foundation

public struct Vonage {
    private let apiKey: String
    private let apiSecret: String
    private let apiHandler = APIHandler()
    
    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    public func requestVerification(with body: RequestVerificationBody, eventLoop: EventLoop) -> EventLoopFuture<String> {
        return apiHandler.sendRequest(
            host: "api.nexmo.com",
            path: "/verify/json",
            body: RequestVerificationBody(body: body, apiKey: apiKey, apiSecret: apiSecret),
            eventLoop: eventLoop
        )
    }
    
    public func checkVerification(with body: CheckVerificationBody, eventLoop: EventLoop) -> EventLoopFuture<String> {
        return apiHandler.sendRequest(
            host: "api.nexmo.com",
            path: "/verify/check/json",
            body: CheckVerificationBody(body: body, apiKey: apiKey, apiSecret: apiSecret),
            eventLoop: eventLoop
        )
    }
    
    public struct RequestVerificationBody: Codable {
        let number: String
        let brand: String?
        let workflowID: Int?
        var apiKey: String?
        var apiSecret: String?
        
        init(body: RequestVerificationBody, apiKey: String, apiSecret: String) {
            self.number = body.number
            self.brand = "SwiftVerify"
            self.workflowID = 6
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
    }
    
    public struct CheckVerificationBody: Codable {
        let requestID: String
        let code: String
        var apiKey: String?
        var apiSecret: String?
        
        init(body: CheckVerificationBody, apiKey: String, apiSecret: String) {
            self.requestID = body.requestID
            self.code = body.code
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
    }
}
