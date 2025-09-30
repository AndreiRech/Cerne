//
//  ProfileViewModelProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    var userPins: [Pin] { get }
    var footprint: String? { get }
    var isLoading: Bool { get  set }
    var totalCO2: String { get }
    var isShowingDeleteAlert: Bool { get set }
    
    func fetchData() async
    func deleteAccount() async
}
