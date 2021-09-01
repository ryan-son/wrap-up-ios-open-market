//
//  MultipartFormData.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/30.
//

import Foundation

enum MultipartFormDataError: Error {

    case fileNotExists
}

final class MultipartFormData {

	// MARK: Namespaces

    enum EncodingCharacter {
        static let crlf = "\r\n"
    }

    enum BoundaryGenerator {

        enum BoundaryType {
            case initial, encapsulated, final
        }

        static func randomBoundary() -> String {
            return "ryanmarket.boundary-\(UUID().uuidString)"
        }

        static func boundaryData(for boundaryType: BoundaryType, boundary: String) -> Data {
            let formattedBoundary: String

            switch boundaryType {
            case .initial:
                formattedBoundary = "--\(boundary)\(EncodingCharacter.crlf)"
            case .encapsulated:
                formattedBoundary = "\(EncodingCharacter.crlf)--\(boundary)\(EncodingCharacter.crlf)"
            case .final:
                formattedBoundary = "\(EncodingCharacter.crlf)--\(boundary)--\(EncodingCharacter.crlf)"
            }

            return Data(formattedBoundary.utf8)
        }
    }

	// MARK: Properties

    private let fileManager: FileManager
    private let boundary: String = BoundaryGenerator.randomBoundary()
    lazy var contentType: String = "multipart/form-data; boundary=\(boundary)"
    private var body = Data()

	// MARK: Initializers

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

	// MARK: Encoding methods

    func encode(parameters: [String: Any?]) -> Data {
        for (key, value) in parameters {
            guard let value = value else { continue }

            if let urls = value as? [URL], urls.count == urls.filter({ $0.isFileURL }).count {
                appendFiles(withName: key, from: urls)
            } else if let url = value as? URL, url.isFileURL {
                appendFile(withName: key, from: url)
            } else {
                append(withName: key, value: value)
            }
        }

        body.append(finalBoundaryData())
        return body
    }

    private func appendFile(withName name: String, from url: URL) {
        let fileName = url.lastPathComponent
        let mimeType = url.mimeType()
        let path = url.path

        if let file = fileManager.contents(atPath: path) {
            body.append(contentHeader(withName: name, fileName: fileName, mimeType: mimeType))
            body.append(file)
        }
    }

    private func appendFiles(withName name: String, from urls: [URL]) {
        urls.forEach {
            let fileName = $0.lastPathComponent
            let mimeType = $0.mimeType()
            let path = $0.path

            if let file = fileManager.contents(atPath: path) {
                body.append(contentHeader(withName: name + "[]", fileName: fileName, mimeType: mimeType))
                body.append(file)
            }
        }
    }

    private func append(withName name: String, fileName: String? = nil, mimeType: String? = nil, value: Any) {
        body.isEmpty ? body.append(initialBoundaryData()) : body.append(encapsulatedBoundaryData())

        if let value = value as? [Any] {
            body.append(contentHeader(withName: name + "[]", fileName: fileName, mimeType: mimeType))
            body.append("\(value)")
        } else {
            body.append(contentHeader(withName: name, fileName: fileName, mimeType: mimeType))
            body.append("\(value)")
        }
    }

    private func contentHeader(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> Data {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName {
            disposition += "; filename=\"\(fileName)\"" + EncodingCharacter.crlf
        } else {
            disposition += EncodingCharacter.crlf + EncodingCharacter.crlf
        }

        var header = "Content-Disposition: \(disposition)"
        if let mimeType = mimeType {
            header.append("Content-Type: \(mimeType)" + EncodingCharacter.crlf + EncodingCharacter.crlf)
        }
        return Data(header.utf8)
    }

	// MARK: Boundary generators

    private func initialBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .initial, boundary: boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .encapsulated, boundary: boundary)
    }

    private func finalBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .final, boundary: boundary)
    }
}
