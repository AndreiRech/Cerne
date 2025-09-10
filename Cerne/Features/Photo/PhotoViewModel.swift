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
    var estimatedHeight: Double = 0.0
    let cameraService: CameraServiceProtocol
    var capturedImage: UIImage?
    var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraServiceProtocol) {
        self.cameraService = cameraService
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
        cameraService.clearImage()
    }
}
