//
//  PushMessageModel.swift
//
//
//  Created by Sanghyeon Park on 4/30/24.
//

import Foundation

import FirebaseFirestore

public struct PushMessageModel: Identifiable, Codable {
    @DocumentID var documentID: String?
    public var title: String
    public var body: String
    public var date: Date
    public var readDate: Date?
    public var targetUID: String
    public var senderUID: String
    public var type: NotificationType
    public var targetTypeID: String
    
    public init(title: String, body: String, date: Date, readDate: Date? = nil, targetUID: String, senderUID: String, type: NotificationType, targetTypeID: String) {
        self.title = title
        self.body = body
        self.date = date
        self.readDate = readDate
        self.targetUID = targetUID
        self.senderUID = senderUID
        self.type = type
        self.targetTypeID = targetTypeID
    }
    
    public var id: String {
        documentID ?? ""
    }
}
