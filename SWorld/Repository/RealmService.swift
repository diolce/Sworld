//
//  RealmService.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 16/11/21.
//

import Foundation
import RealmSwift


class RealmService {
    private init() {}
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    func createOrUpdate<T:Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {}
    }
    
    func delete<T:Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {}
    }
}
