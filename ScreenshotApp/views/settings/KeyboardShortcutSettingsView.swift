//
//  KeyboardcutSettingsView.swift
//  ScreenshotApp
//
//  Created by Karin Prater on 13/05/2024.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutSettingsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("识别文字:",
                                       name: .screenshotCapture)
            KeyboardShortcuts.Recorder("识别窗体文字:",
                                       name: .screenshotCaptureWindow)
            KeyboardShortcuts.Recorder("识别全屏文字:",
                                       name: .screenshotCaptureFull)
            KeyboardShortcuts.Recorder("翻译:",
                                       name: .translate)
        }
        .padding()
    }
}

#Preview {
    KeyboardShortcutSettingsView()
}
