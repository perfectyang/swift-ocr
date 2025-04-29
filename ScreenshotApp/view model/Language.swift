//
//  Language.swift
//  ScreenshotApp
//
//  Created by perfectyang on 2024/12/16.
//


public struct Language: Decodable {
    public typealias Code = String

    public let code: Code
    public let name: String
}
