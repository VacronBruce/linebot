//
//  MessageEvent.swift
//  
//
//  Created by 輝浚 on 2021/1/26.
//

public struct MessageEvent: Decodable {
    public let replyToken: String
    public let type: String
    public let mode: String
    public let timestamp: Int
    public let source: Source
    public let message: Message
}
