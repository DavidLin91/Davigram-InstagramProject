//
//  ProfileVC.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileVC: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var displayNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    private var selectedImage: UIImage? {
        didSet {
            profilePicture.image = selectedImage
        }
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        profilePicture.layer.cornerRadius = 5.0
        updateProfileButton.layer.cornerRadius = 5.0
        editPhotoButton.layer.cornerRadius = editPhotoButton.frame.width/2
        
    }
    
    private let storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        emailLabel.text = user.email
        displayNameLabel.text = user.displayName
        profilePicture.kf.setImage(with: user.photoURL)
    }
    
    @IBAction func updateProfileButtonClicked(_ sender: UIButton) {
        guard let displayName = displayNameLabel.text,
            !displayName.isEmpty,let selectedImage = selectedImage  else {
                print("missing field")
                return
        }
        guard let user = Auth.auth().currentUser else { return }
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profilePicture.bounds)
        print("original image size: \(selectedImage.size)")
        
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
            //code here to add photoURL to the user's photoURL proeprty then commit changes
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url
                request?.commitChanges(completion: { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Change", message: "Error changing profile: \(error)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Update", message: "Profile successfully updated")
                        }
                    }
                })
            }
        }
    }
    
    
    
    @IBAction func editPhotoButtonClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Edit Photo", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default)
        { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "Login", viewControllerId: "LoginVC")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error)")
            }
        }
    }
}


extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

