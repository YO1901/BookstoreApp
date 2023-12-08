//
//  AccountViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class AccountViewController: UIViewController, AccountInput {
    
    var presenter: AccountOutput!
    
    private let avatar = AvatarView()
    private lazy var nameTextField = NamedTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        presenter.activate()
    }
    
    func update(with model: ViewModel) {
        nameTextField.update(
            model: .init(
                name: NSAttributedString(
                    string: "Name:",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14),
                        .foregroundColor: UIColor.black
                    ]
                ),
                textFieldText: model.name,
                textFieldFont: .systemFont(ofSize: 16, weight: .semibold),
                textFieldColor: Colors.blackPrimary,
                didEnterText: model.didChangeName
            )
        )
        if let imageData = model.image {
            avatar.update(model: .init(image: UIImage(data: imageData)))
        }
    }
    
    private func configure() {
        title = "Acccount"
        
        view.backgroundColor = Colors.Background.lvl1
        
        view.addSubview(avatar)
        avatar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.size.equalTo(100)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(avatar.snp.bottom).offset(26)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        tapGR.cancelsTouchesInView = false
        avatar.addGestureRecognizer(tapGR)
    }
    
    @objc
    private func didTapAvatar() {
        presenter.didTapAvatar()
    }
    
    func showImagePicker() {
        let controller = UIImagePickerController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension AccountViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        if let image = info[.originalImage] as? UIImage,
            let imageData = image.resizeImage(minSide: 120)?.jpegData(compressionQuality: 1.0) {
            presenter.didSelectAvatar(imageData)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController {
    struct ViewModel {
        let image: Data?
        let name: String
        let didChangeName: (String) -> Void
    }
}
