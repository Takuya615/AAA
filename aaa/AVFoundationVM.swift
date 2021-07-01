//
//  AVFoundationVM.swift
//  aaa
//
//  Created by user on 2021/06/22.
//

//import Foundation

import UIKit
import Combine
import AVFoundation

class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    ///撮影した画像
    @Published var image: UIImage?
    ///プレビュー用レイヤー
    var previewLayer:CALayer!

    ///撮影開始フラグ
    private var _takePhoto:Bool = false
    ///セッション
    private let captureSession = AVCaptureSession()
    ///撮影デバイス
    private var capturepDevice:AVCaptureDevice!

    override init() {
        super.init()

        prepareCamera()
        beginSession()
    }

    func takePhoto() {
        _takePhoto = true
    }

    private func prepareCamera() {
        captureSession.sessionPreset = .photo

        //カメラの向き修正
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first {
            capturepDevice = availableDevice
        }
    }

    private func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)

            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer

        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }

        captureSession.commitConfiguration()

        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }

    func startSession() {
        if captureSession.isRunning { return }
        captureSession.startRunning()
    }

    func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if _takePhoto {
            _takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
                    
                    
                    
                    
                    
                    
                    
                    print("ポーズ　ディテクしょん")
                    PoseDetection().pose(image: image)
                    
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }

    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()

            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }

        return nil
    }
}





//ビデオ撮影できる　クラス
import Firebase

class ViewController2: UIViewController, AVCaptureFileOutputRecordingDelegate {
    let fileOutput = AVCaptureMovieFileOutput()

    var recordButton: UIButton!
    var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpCamera()
    }

    func setUpCamera() {
        

        let captureSession: AVCaptureSession = AVCaptureSession()
        let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(
            .builtInWideAngleCamera,for: AVMediaType.video,position: .front)//( カメラの方向　前・後ろの設定
            //for: AVMediaType.video)
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

        // video input setting
        let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // audio input setting
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        captureSession.addOutput(fileOutput)

        captureSession.startRunning()

        // video preview layer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect//fill　　アスペクト比の調整
        self.view.layer.addSublayer(videoLayer)

        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.recordButton.backgroundColor = UIColor.red
        self.recordButton.layer.masksToBounds = true
        self.recordButton.layer.cornerRadius = self.recordButton.frame.width/2
        self.recordButton.setTitle("Record", for: .normal)
        //self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 120)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
        
        /*
        //back Button
        self.backButton = UIButton(frame:CGRect(x: 0, y: 0, width: 100, height: 50))
        self.backButton.layer.masksToBounds = true
        //self.recordButton.layer.cornerRadius = self.recordButton.frame.width/2
        self.backButton.setTitle("Record", for: .normal)
        //self.recordButton.layer.cornerRadius = 20
        self.backButton.layer.position = CGPoint(x: 100/*self.view.bounds.width / 2*/, y:100/*self.view.bounds.height - 100*/)
        self.backButton.addTarget(self, action: self.appState.isVideoMode = false, for: .touchUpInside)
        self.view.addSubview(backButton)
 */
    }

    @objc func onClickRecordButton(sender: UIButton) {
        if self.fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()

            self.recordButton.backgroundColor = .red//gray
            self.recordButton.setTitle("Record", for: .normal)
        } else {
            // start recording
            let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")//保存する動画のファイル名
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            //let avCaptureConnection = AVCaptureConnection()
            //fileOutput?(fileOutput, didStartRecordingTo: fileURL, from: avCaptureConnection)
            
            self.recordButton.backgroundColor = .gray//red
            self.recordButton.setTitle("●Recording", for: .normal)
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        let uid = String(Auth.auth().currentUser!.uid)//uidの設定
        //日時の指定
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        //let date = dateFormatter.string(from: Date())
        //ビデオ保存用
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SSS"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        //FireBase  Storage
        //let localFile = URL(string: "path/to/image")!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child("\(uid) /\(date).mp4")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putFile(from: outputFileURL, metadata: metadata) { metadata, error in
          riversRef.downloadURL { (url, error) in
            guard url != nil else {// Uh-oh, an error occurred! エラーした場合の記述
                print("動画保存　URL生成")
                return
            }
            
            //ここでURLを保存できそう！！！
            let db = Firestore.firestore()
            db.collection(uid).document(date).setData([
                "date": date,
                "url": url!.absoluteString
            ]) { err in
                if let err = err {
                    print("URLと日時　Error adding document: \(err)")
                } else {
                    print("URLと日時　Document added")
                }
            }
            
            
            
          }
        }
            
        
        // show alert
        let alert: UIAlertController = UIAlertController(title: "Recorded!", message: outputFileURL.absoluteString, preferredStyle:  .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
        // ライブラリへの保存
        /*PHPhotoLibrary.shared().performChanges({
         PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
     }) { completed, error in
         if completed {
             print("Video is saved!")
         }
     }**/
            
    
}
