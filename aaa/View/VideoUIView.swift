//
//  VideoUIView.swift
//  aaa
//
//  Created by user on 2021/06/17.
//

//import AVFoundation
import SwiftUI
//import AssetsLibrary


//カメラのビュー
struct CALayerView: UIViewControllerRepresentable {
     var caLayer:CALayer

     func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
         let viewController = ViewController2()//UIViewController()

         viewController.view.layer.addSublayer(caLayer)
         caLayer.frame = viewController.view.layer.frame

         return viewController
     }

     func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
         caLayer.frame = uiViewController.view.layer.frame
     }
 }











/*

struct VideoUIView: View {
    @ObservedObject var presenter: SimpleVideoCapturePresenter
    var body: some View {
        ZStack {
            //Text("asd")
            CALayerView(caLayer: presenter.previewLayer)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.presenter.apply(inputs: .onAppear)
        }
        .onDisappear {
            self.presenter.apply(inputs: .onDisappear)
        
        }
    }
}

struct CALayerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    var caLayer: CALayer

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}


struct VideoUIView_Previews: PreviewProvider {
    static var previews: some View {
        VideoUIView(presenter:SimpleVideoCapturePresenter())
    }
}


final class SimpleVideoCapturePresenter: ObservableObject {
    
    var previewLayer: CALayer {
        return interactor.previewLayer!
    }

    enum Inputs {
        case onAppear
        case tappedCameraButton
        case onDisappear
    }

    init() {
        interactor.setupAVCaptureSession()
    }

    func apply(inputs: Inputs) {
        switch inputs {
            case .onAppear:
                interactor.startSettion()
            break
            case .tappedCameraButton:
            break
            case .onDisappear:
              interactor.stopSettion()
        }
    }

    // MARK: Privates
    private let interactor = SimpleVideoCaptureInteractor()
}

import Foundation
import AVKit
final class SimpleVideoCaptureInteractor: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureDevice: AVCaptureDevice?
    
    func setupAVCaptureSession() {
             print(#function)
             captureSession.sessionPreset = .photo
             if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first {
                 captureDevice = availableDevice
             }

             do {
                 let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!)
                 captureSession.addInput(captureDeviceInput)
             } catch let error {
                 print(error.localizedDescription)
             }

             let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.name = "CameraPreview"
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.backgroundColor = UIColor.black.cgColor
             self.previewLayer = previewLayer

             let dataOutput = AVCaptureVideoDataOutput()
             dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

             if captureSession.canAddOutput(dataOutput) {
                 captureSession.addOutput(dataOutput)
             }
             captureSession.commitConfiguration()
         }

        func startSettion() {
            if captureSession.isRunning { return }
            captureSession.startRunning()
        }

        func stopSettion() {
            if !captureSession.isRunning { return }
            captureSession.stopRunning()
        }
    
}
 */


