//
//  UserService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import CloudKit

class UserService: UserServiceProtocol {
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    init() {}
    
    func fetchUsers() async throws -> [User] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_User", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            
            return records.compactMap { User(record: $0) }
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func fetchUser(by recordID: CKRecord.ID) async throws -> User? {
        do {
            let record = try await publicDB.record(for: recordID)
            return User(record: record)
        } catch let error as CKError where error.code == .unknownItem {
            print("Utilizador com recordID \(recordID.recordName) não encontrado.")
            return nil
        } catch {
            print("Erro ao buscar utilizador por recordID: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func fetchOrCreateCurrentUser(name: String?, height: Double?) async throws -> User {
        let container = CKContainer.default()
        
        do {
            let userRecordID = try await container.userRecordID()
            let userIDString = userRecordID.recordName
            
            let predicate = NSPredicate(format: "CD_id == %@", userIDString)
            let query = CKQuery(recordType: "CD_User", predicate: predicate)
            
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = matchResults.compactMap { try? $0.1.get() }

            if let existingRecord = records.first, let user = User(record: existingRecord) {
                return user
            } else {
                guard let name, let height = height else {
                    throw GenericError.serviceError
                }
                
                guard (1.0...3.0).contains(height) else {
                    throw UserValidationError.invalidHeight
                }
                
                guard name.count >= 3 else {
                    throw UserValidationError.nameTooShort
                }
                
                let newUserRecord = CKRecord(recordType: "CD_User")
                newUserRecord["CD_id"] = userIDString
                newUserRecord["CD_name"] = name
                newUserRecord["CD_height"] = height
                
                let savedRecord = try await publicDB.save(newUserRecord)
                
                guard let newUser = User(record: savedRecord) else {
                    throw GenericError.serviceError
                }
                return newUser
            }
        } catch {
            print("Erro detalhado do CloudKit em fetchOrCreateCurrentUser: \(error)")
            print("Descrição Localizada em fetchOrCreateCurrentUser: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func fetchCurrentUserIfExists() async throws -> User? {
        let container = CKContainer.default()
        
        do {
            let userRecordID = try await container.userRecordID()
            let userIDString = userRecordID.recordName

            let predicate = NSPredicate(format: "CD_id == %@", userIDString)
            let query = CKQuery(recordType: "CD_User", predicate: predicate)

            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = matchResults.compactMap { try? $0.1.get() }

            if let existingRecord = records.first, let user = User(record: existingRecord) {
                CacheService.shared.set(user, forKey: .currentUser)
                return user
            } else {
                return nil
            }
        } catch let error as CKError where error.code == .notAuthenticated {
             print("Erro: Usuário não autenticado no iCloud. \(error.localizedDescription)")
             throw UserError.iCloudAccountNotFound
        } catch {
            print("Erro ao tentar buscar usuário existente: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func updateUser(user: User) async throws -> User {
        guard let recordID = user.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            let recordToUpdate = try await publicDB.record(for: recordID)
            
            guard (1.0...3.0).contains(user.height) else {
                throw UserValidationError.invalidHeight
            }
            
            guard user.name.count >= 3 else {
                throw UserValidationError.nameTooShort
            }
            
            recordToUpdate["CD_name"] = user.name
            recordToUpdate["CD_height"] = user.height
            
            let updatedRecord = try await publicDB.save(recordToUpdate)
            
            guard let updatedUser = User(record: updatedRecord) else {
                throw GenericError.serviceError
            }
            return updatedUser
            
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func deleteUser(_ user: User) async throws {
        guard let recordID = user.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            try await publicDB.deleteRecord(withID: recordID)
        } catch {
            throw GenericError.serviceError
        }
    }
}
