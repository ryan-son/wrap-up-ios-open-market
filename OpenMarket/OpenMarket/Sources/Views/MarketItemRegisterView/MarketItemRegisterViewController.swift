//
//  MarketItemRegisterViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import UIKit

final class MarketItemRegisterViewController: UIViewController {

    private let viewModel = MarketItemRegisterViewModel()
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        viewModel.marketItem = MarketItem(id: 1234,
                                          title: "ABCDE",
                                          descriptions: "abcde",
                                          price: 12000,
                                          currency: "KRW",
                                          stock: 10,
                                          discountedPrice: 10000,
                                          thumbnails: ["abc"],
                                          images: nil,
                                          registrationDate: Date().timeIntervalSince1970)
        viewModel.password = "1234"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openLibrary()
    }
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }

    // bind with viewModel + marketItem
}

extension MarketItemRegisterViewController: UINavigationControllerDelegate { }

extension MarketItemRegisterViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let imageURL = info[.imageURL] as? URL else { return }
        viewModel.images.append(imageURL)
        dismiss(animated: true) {
            print(self.viewModel.images)
            self.viewModel.upload(by: .post)
        }
    }
}
