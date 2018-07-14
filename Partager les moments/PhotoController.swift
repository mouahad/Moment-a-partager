//
//  PhotoController.swift
//  Partager les moments
//
//  Created by MYD on 14/07/2018.
//  Copyright © 2018 MYD. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //POUR un appareille photo on a besoin de 2 delegates : UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    @IBOutlet weak var partagerBouton: UIBarButtonItem!
    @IBOutlet weak var photoAPartager: UIImageView!
    @IBOutlet weak var texteAPartager: UITextView!
    
    let textVide = "Entrez un texte ..."
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mep()

    }
    
    func mep() {
        photoAPartager.contentMode = .scaleAspectFit
        photoAPartager.image = #imageLiteral(resourceName: "Superman-facebook.svg")
        photoAPartager.isUserInteractionEnabled = true  //autoriser que l'on puisse interagire sur "photoAPartager"
        let tap = UITapGestureRecognizer(target: self, action: #selector(prendrePhoto))
        photoAPartager.addGestureRecognizer(tap)
        
        
        texteAPartager.text = textVide
        texteAPartager.delegate = self
        
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true   //SI on peu redimmensionner les photos
        
        
    }
    
    // Protocole pour l'appareil photo.
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)       //
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var image: UIImage?
        
        if let editee = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editee
        } else if let originale = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originale
        }
            
        photoAPartager.image = image
        imagePicker?.dismiss(animated: true, completion: nil)   // une fois la photo assigner il faut fermer l'imagePicker
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textVide {
            textView.text = ""
        }
    }
    
    
    @objc func prendrePhoto(){
        guard imagePicker != nil else {return}
        
        let alerte = UIAlertController(title: "Prendre photo", message: "Choisir media", preferredStyle: .actionSheet)
        
        
        
        let appareil = UIAlertAction(title: "Appareil photo", style: .default) { (act) in if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }
        
        
        
        let librairie = UIAlertAction(title: "Librairie de photo", style: .default) { (action) in
            self.imagePicker?.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        
        let annuler = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        
        
        alerte.addAction(appareil)
        alerte.addAction(librairie)
        alerte.addAction(annuler)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let pop = alerte.popoverPresentationController {
                pop.sourceView = self.view  //recuper la vue principal
                pop.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
                pop.permittedArrowDirections = [] // pas vouloir mettre de fleche de direction
            }
        }
        
        
        self.present(alerte, animated: true, completion: nil)
    }
    
    
    @IBAction func boutonPartager(_ sender: Any) {
        var contenuAPartager: [Any] = [Any]()
        
        
        if let image = photoAPartager.image, image != #imageLiteral(resourceName: "Superman-facebook.svg") {
            contenuAPartager.append(image)
        }
        
        if texteAPartager.text != "", texteAPartager.text != textVide  {
            contenuAPartager.append(texteAPartager.text)
        }
        
        let activity = UIActivityViewController(activityItems: contenuAPartager, applicationActivities: nil)
        
                    // pour ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let pop = activity.popoverPresentationController {
                pop.sourceView = self.view  //recuper la vue principal
                pop.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
                pop.permittedArrowDirections = [] // pas vouloir mettre de fleche de direction
            }
        }
        //  self.present(activity, animated: true, completion: nil)   ou ->
        self.present(activity, animated: true) {
            self.mep()
        }
        
    }
    
}
















