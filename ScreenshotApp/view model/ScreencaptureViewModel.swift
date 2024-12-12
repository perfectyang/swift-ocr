//
//  ScreencaptureViewModel.swift
//  ScreenshotApp
//
//  Created by Karin Prater on 13/05/2024.
//

import SwiftUI
import KeyboardShortcuts
import Vision
import Foundation
import AppKit



class ScreencaptureViewModel: ObservableObject {
    
    private var currentResult: Recognizer.ResultData?
    // 获取 AppDelegate 实例
    
    enum ScreenshotTypes {
        case full
        case window
        case area
        
        var processArguments: [String] {
            switch self {
                case .full:
                    ["-c"]
                case .window:
                    ["-cw"]
                case .area:
                    ["-cs"]
            }
        }
    }
    
    
   @Published var images = [NSImage]()

   init() {
        KeyboardShortcuts.onKeyUp(for: .cutImage) { [self] in
            self.takeScreenshot(for: .area)
        }
        KeyboardShortcuts.onKeyUp(for: .screenshotCapture) { [self] in
            self.takeScreenshot(for: .area)
        }
        
        KeyboardShortcuts.onKeyUp(for: .screenshotCaptureFull) { [self] in
            self.takeScreenshot(for: .full)
        }
        
        KeyboardShortcuts.onKeyUp(for: .screenshotCaptureWindow) { [self] in
            self.takeScreenshot(for: .window)
        }
    }
    
    func takeScreenshot(for type: ScreenshotTypes) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = type.processArguments
        
        do {
            try task.run()
            task.waitUntilExit()
            getImageFromPasteboard()
        } catch {
            print("could not take screenshot: \(error)")
        }
    }
    
   
    private func showResult (_ resultData: Recognizer.ResultData) {
        guard currentResult != resultData else {
          #if DEBUG
            print("No change in result data")
          #endif
          return
        }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(resultData.lineBreaksJoined, forType: .string)
        print("识别图片中的文字:---->" + resultData.lineBreaksJoined)
    }
    
    
   private func getImageFromPasteboard() {
        guard NSPasteboard.general.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else { return }
        
        guard let image =  NSImage(pasteboard: NSPasteboard.general) else { return }
       
       if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
           // 现在您有一个 CGImage 对象
              Task {
                let fastResult = await Recognizer.detect(image: cgImage, level: .fast)
                  showResult(fastResult)
                let accurateResult = await Recognizer.detect(image: cgImage, level: .accurate)
                  showResult(accurateResult)
              }
       } else {
           print("无法将 NSImage 转换为 CGImage")
       }
        self.images.append(image)
    }
}
