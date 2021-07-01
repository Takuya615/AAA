//
//  PoseDetection.swift
//  aaa
//
//  Created by user on 2021/06/30.
//

import Foundation
import MLKit

class PoseDetection {
    
    func pose(image:UIImage){
        // Base pose detector with streaming, when depending on the PoseDetection SDK
            let options = PoseDetectorOptions()
            options.detectorMode = .stream
            let poseDetector = PoseDetector.poseDetector(options: options)
            
            let image = VisionImage(image: image)
            //VisionImage.orientation = image.imageOrientation
        
        var results: [Pose]?
        do {
          results = try poseDetector.results(in: image)
        } catch let error {
          print("Failed to detect pose with error: \(error.localizedDescription).")
          return
        }
        guard let detectedPoses = results, !detectedPoses.isEmpty else {
          print("Pose detector returned no results.")
          return
        }

        for pose in detectedPoses {
          let leftAnkleLandmark = pose.landmark(ofType: .leftAnkle)
          if leftAnkleLandmark.inFrameLikelihood > 0.5 {
            let position = leftAnkleLandmark.position
            print("左かたの座標\(position)")
          }
        }
    }
    
    
}

