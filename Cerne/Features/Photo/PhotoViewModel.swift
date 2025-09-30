//
//  PhotoViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import SwiftUI
import Combine

@Observable
class PhotoViewModel: PhotoViewModelProtocol {
    let cameraService: CameraServiceProtocol
    let treeAPIService: TreeAPIServiceProtocol
    let userDefaultService: UserDefaultServiceProtocol
    
    var isLoading: Bool = false
    var capturedImage: UIImage?
    var identifiedTree: TreeResponse?
    var errorMessage: String?
    
    var showInfo: Bool = true
    var isMeasuring: Bool = false
    var shouldNavigate: Bool = false
    var isIdentifying: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraServiceProtocol, treeAPIService: TreeAPIServiceProtocol, userDefaultService: UserDefaultServiceProtocol) {
        self.cameraService = cameraService
        self.treeAPIService = treeAPIService
        self.userDefaultService = userDefaultService
        subscribeToPublishers()
        
        showInfo = userDefaultService.isFirstTime()
        if !showInfo {
            isMeasuring = true
        }
    }
    
    private func subscribeToPublishers() {
        cameraService.capturedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.capturedImage = image
                self?.errorMessage = self?.cameraService.errorMessage
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        Task {
            if await cameraService.requestPermissions() {
                (cameraService as? CameraService)?.setup()
                cameraService.startSession()
            } else {
                errorMessage = cameraService.errorMessage
            }
        }
    }
    
    func onDisappear() {
        cameraService.stopSession()
    }
    
    func capturePhoto() {
        cameraService.capturePhoto()
    }
    
    func retakePhoto() {
        identifiedTree = nil
        capturedImage = nil
        isIdentifying = false
        isLoading = false
    }
    
    func identifyTree(image: UIImage) async {
        isLoading = true
        isIdentifying = true
        
        defer {
            isLoading = false
        }
        
        do {
            let result = try await treeAPIService.identifyTree(image: image)
            self.identifiedTree = result
        } catch let error as NetworkError {
            self.errorMessage = error.errorDescription
        } catch {
            self.errorMessage = "Ocorreu um erro inesperado: \(error.localizedDescription)"
        }
    }
}
