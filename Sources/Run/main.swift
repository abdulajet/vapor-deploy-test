import Vapor
import SwiftVerify

let app = try Application(.detect())
let client = Vonage(apiKey: Environment.get("APIKEY")!, apiSecret: Environment.get("APISECRET")!)

defer { app.shutdown() }

app.post("request") { req -> EventLoopFuture<ClientResponse> in
    let body = try req.content.decode(Vonage.RequestVerificationBody.self)
    return client.requestVerification(with: body, client: req.client)
}

app.post("check") { req -> EventLoopFuture<ClientResponse> in
    let body = try req.content.decode(Vonage.CheckVerificationBody.self)
    return client.checkVerification(with: body, client: req.client)
}

try app.run()
