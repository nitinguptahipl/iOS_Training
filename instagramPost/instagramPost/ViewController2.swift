//
//  ViewController2.swift
//  instagramPost
//
//  Created by HIPLMACBOOK14 on 16/12/24.
//
 
import UIKit
 
class ViewController2: UIViewController {
    @IBOutlet weak var displayImg: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var contentImg: UIImageView!
    var tappedImageView: UIImageView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        displayImg.layer.cornerRadius = displayImg.frame.height / 2
        // Add tap gesture to displayImg
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        displayImg.isUserInteractionEnabled = true
        displayImg.addGestureRecognizer(tapGestureRecognizer)
        
        
        // Add tap gesture to contentImg
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        contentImg.isUserInteractionEnabled = true
        contentImg.addGestureRecognizer(tapGestureRecognizer2)
        
        
        
    }
    
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        tappedImageView = sender.view as? UIImageView
        presentActionSheet()
    }
    
    @IBAction func submit(_ sender: Any) {
        
        guard let userNameText = userName.text, !userNameText.isEmpty,
              let captionText = caption.text, !captionText.isEmpty,
              let displayImage = displayImg.image,
              let contentImage = contentImg.image else {
            showAlert(title: "Error", message: "All fields and images are required!")
            return
        }
        
        
        let profileImageData = displayImage.jpegData(compressionQuality: 1.0)!
        let contentImageData = contentImage.jpegData(compressionQuality: 1.0)!
        
        PersistentStorage.shared.createData(postedByName: userNameText, postedByDP: profileImageData, postImg: contentImageData, caption: captionText, date: Date.now)
        
        let alert = UIAlertController(title: "Successfully Posted", message: "Posted successfully!!!!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        alert.dismiss(animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
        
        
    }
}
 
extension ViewController2: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentActionSheet() {
        let title = tappedImageView == displayImg ? "Profile Picture" : "Content Picture"
        let actionSheet = UIAlertController(title: title,
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    func presentPhotoLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        tappedImageView?.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
