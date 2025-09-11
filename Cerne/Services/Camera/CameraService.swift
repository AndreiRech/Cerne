//
//  CameraService.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

class CameraService: NSObject, ObservableObject, CameraServiceProtocol, AVCapturePhotoCaptureDelegate {
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    var capturedImagePublisher: Published<UIImage?>.Publisher { $capturedImage }
    var errorMessage: String?
    
    @Published private var capturedImage: UIImage?
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    override init() {
        super.init()
        setupSession()
    }
    
    func requestPermissions() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            errorMessage = "Erro: Permissão de câmera não concedida."
            return false
        }
    }
    
    func startSession() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func clearImage() {
        DispatchQueue.main.async {
            self.capturedImage = nil
        }
        
        if !session.isRunning {
            startSession()
        }
        
        DispatchQueue.main.async {
            self.previewLayer.connection?.isEnabled = false
            self.previewLayer.connection?.isEnabled = true
        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            errorMessage = "Erro: Não foi possível configurar o dispositivo de entrada de vídeo."
            session.commitConfiguration()
            return
        }
        session.addInput(videoDeviceInput)
        
        guard session.canAddOutput(photoOutput) else {
            errorMessage = "Erro: Não foi possível adicionar a saída de foto."
            session.commitConfiguration()
            return
        }
        session.addOutput(photoOutput)
        
        session.commitConfiguration()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            errorMessage = "Erro ao capturar foto: \(error.localizedDescription)"
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            errorMessage = "Erro: Não foi possível criar a imagem a partir dos dados."
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
