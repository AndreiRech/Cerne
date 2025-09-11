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
    
    var isLoading: Bool = false
    var capturedImage: UIImage?
    var identifiedTree: TreeResponse?
    var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraServiceProtocol, treeAPIService: TreeAPIServiceProtocol) {
        self.cameraService = cameraService
        self.treeAPIService = treeAPIService
        subscribeToPublishers()
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
        isLoading = false
        
        cameraService.clearImage()
    }
    
    func identifyTree(image: UIImage) async {
        isLoading = true
        
        defer { isLoading = false }
        
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
