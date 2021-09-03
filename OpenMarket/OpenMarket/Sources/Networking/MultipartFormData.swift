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

protocol MultipartFormDataEncodable {

    var boundary: String { get }
    var contentType: String { get }
    func encode(parameters: [String: Any?]) -> Data
}

final class MultipartFormData: MultipartFormDataEncodable {

	// MARK: Namespaces

    enum EncodingCharacter {
        static let crlf = "\r\n"
    }

    enum BoundaryGenerator {

        enum BoundaryType {
            case initial, encapsulated, final
        }

        static func randomBoundary() -> String {
            return "ryan-market.boundary-\(UUID().uuidString)"
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

    let boundary: String
    lazy var contentType: String = "multipart/form-data; boundary=\(boundary)"
	private let jpegMimeType: String = "image/jpeg"
	private let jpegPathExtension: String = ".jpeg"
    private var body = Data()

	// MARK: Initializers

    init(boundary: String? = nil) {
        self.boundary = boundary ?? BoundaryGenerator.randomBoundary()
    }

	// MARK: Encoding methods

    func encode(parameters: [String: Any?]) -> Data {
        for (key, value) in parameters {
            guard let value = value else { continue }

            if let images = value as? [Data] {
                appendImages(withName: key, from: images)
            } else if let data = value as? Data {
                appendImage(withName: key, from: data)
            } else {
                append(withName: key, value: value)
            }
        }

        body.append(finalBoundaryData())
        return body
    }

    private func appendImage(withName name: String, from data: Data) {
		body.isEmpty ? body.append(initialBoundaryData()) : body.append(encapsulatedBoundaryData())

		let fileName = UUID().uuidString + jpegPathExtension

		body.append(contentHeader(withName: name, fileName: fileName, mimeType: jpegMimeType))
		body.append(data)
    }

    private func appendImages(withName name: String, from datas: [Data]) {
        datas.forEach {
			body.isEmpty ? body.append(initialBoundaryData()) : body.append(encapsulatedBoundaryData())

			let fileName = UUID().uuidString + jpegPathExtension

			body.append(contentHeader(withName: name + "[]", fileName: fileName, mimeType: jpegMimeType))
			body.append($0)
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
