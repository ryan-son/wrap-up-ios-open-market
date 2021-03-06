//
//  RegisterImagePicker.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/31.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {

    func didSelectImage(_ image: UIImage?)
}

final class ImagePicker: NSObject {

	// MARK: Type properties

	static private let allowedMediaTypes: [String] = ["public.image"]

	// MARK: Properties

    private let imagePickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

	// MARK: Initializers

    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.mediaTypes = ImagePicker.allowedMediaTypes
    }

	// MARK: Trigger picker view

    private func sourceTypeSelectionAlertAction(for sourceType: UIImagePickerController.SourceType,
                                                title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return nil }
        let alertAction = UIAlertAction(title: title, style: .default) { _ in
            self.imagePickerController.sourceType = sourceType
            self.presentationController?.present(self.imagePickerController, animated: true)
        }
        return alertAction
    }

    func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: "사진을 어디서 가져올까요?", message: nil, preferredStyle: .actionSheet)

        if let photoLibraryAction = sourceTypeSelectionAlertAction(for: .photoLibrary, title: "사진첩") {
            alertController.addAction(photoLibraryAction)
        } else if let savedPhotosAlbumAction = sourceTypeSelectionAlertAction(for: .savedPhotosAlbum, title: "저장된 사진 앨범") {
            alertController.addAction(savedPhotosAlbumAction)
        } else if let cameraAction = sourceTypeSelectionAlertAction(for: .camera, title: "카메라 촬영") {
            alertController.addAction(cameraAction)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }

        presentationController?.present(alertController, animated: true)
    }

	// MARK: Picking finished

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true)
        delegate?.didSelectImage(image)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            pickerController(picker, didSelect: nil)
            return
        }

        pickerController(picker, didSelect: image)
    }
}

// MARK: - UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate { }
