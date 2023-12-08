//
//  FirebaseManager.swift
//  Capstone_2
//
//  Created by Nicode . on 11/18/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseMessaging
import CoreLocation


class FirebaseManager : NSObject {
    let auth : Auth
    let storage : Storage // 바이너리 파일을 저장하는 파이어 베이스 기능
    let firestore : Firestore // nosql을 이용한 db 파이어 베이스 기능
    
    static let shared = FirebaseManager()
    
    override init(){
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
