import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get("cometome") { req -> String in
        return "TEST ME!!"
        
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.post("callback") {req -> HTTPResponseStatus in
        //1. verify signature
        if let signature = req.headers["X-Line-Signature"].first,
           let requestBody: String = req.body.string {
            let channelSecret = "e557823594bfc4e7ef9aea752c2cfb7e";
            let webhook = WebhookParser.init(channelSecret: channelSecret);
            let events = webhook.parse(body: requestBody, signature: signature);
            NSLog(requestBody);
            let bot = LineBotApi(channelAccessToken: "xxMW/hR/Z1TaPamQcE9N2wVuZWKt5l3lH/vnilkgEMEo1W4iaOwajNosYp6DteX3RUZRnaHjCvNlyjrfCsSXt0AZVO9sTmCHtJeroMvHlkpiDZaqrqRUJQqLGMytThvJNhQdYsU6ZTA98lu8QEnCRwdB04t89/1O/w1cDnyilFU=");
            
            for event in events! {
                switch event {
                case .message(let messageEvent):
                    let token = messageEvent.replyToken;
                    NSLog(token);
                    let text = messageEvent.message.text;
                    let textMsg = TextSendMessage.init(text: text!);
                    let request = bot.replyMessage(replyToken: token, message: textMsg);
                    req.client.send(request);
                    break;
                case .follow(let followEvent):
                    let token = followEvent.replyToken;
                    NSLog(token);
                    break;
                }
            }
            
        }
        //3. reply messages
        return HTTPStatus.ok;
    }
    try app.register(collection: TodoController())
}
