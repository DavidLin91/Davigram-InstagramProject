//
//  AddImageVC.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/5/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore

class AddImageVC: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    private var imagePicker = UIImagePickerController()
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private var chosenCategory = String()
    
    var categoryData: [String] = [String]()
    
    private var selectedPhoto: UIImage? {
        didSet {
            photo.image = selectedPhoto
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        photo.layer.cornerRadius = 5.0
        postButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryData = ["funny", "travel", "food", "fitness", "hobby", "nsfw"].map{ ($0.capitalized)}.sorted()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
//        postButton.isEnabled = false
        
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        guard let photoText = photoTextView.text,
            !photoText.isEmpty,
            
            let selectedPhoto = selectedPhoto else {
                showAlert(title: "Missing Fields", message: "All fields are required")
                return
        }

        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please go to the profile to complete your settings")
            return
        }

        let resizedImage = UIImage.resizeImage(originalImage: selectedPhoto, rect: photo.bounds)

        dbService.createPicture(photoDescription: photoText, category: chosenCategory, userName: displayName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Sorry, something went wrong", message: "Unable to upload image: \(error.localizedDescription).")
                }
            case .success(let documentId):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "")
                }
                self?.uploadPhoto(photo: resizedImage, documentId : documentId)
            }
        }
        
    }
    
    
    @IBAction func addPhotoButtonClicked(_ sender: UIBarButtonItem) {
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    
    
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(photoId: documentId, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateItemImageURL(url, documentId: documentId)
                
            }
        }
    }
    
    private func updateItemImageURL(_ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.photosCollection).document(documentId).updateData(["imageURL": url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    
    
}

extension AddImageVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryData.count
    }
}

extension AddImageVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categoryData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categoryData[row]
        chosenCategory = selectedCategory
        return
    }
}



extension AddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedPhoto = image
        dismiss(animated: true)
    }
}
