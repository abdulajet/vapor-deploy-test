import Vapor

let app = try Application(.detect())
let client = Vonage(apiKey: Environment.get("apiKey")!, apiSecret: Environment.get("apiSecret")!)

defer { app.shutdown() }

app.post("request") { req -> EventLoopFuture<String> in
    let body = try req.content.decode(Vonage.RequestVerificationBody.self)
    return client.requestVerification(with: body, eventLoop: req.eventLoop)
}

app.post("check") { req -> EventLoopFuture<String> in
    let body = try req.content.decode(Vonage.CheckVerificationBody.self)
    return client.checkVerification(with: body, eventLoop: req.eventLoop)
}

try app.run()
