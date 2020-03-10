//
//  ExploreVC.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import FirebaseFirestore

class ExploreVC: UIViewController {
    
    @IBOutlet weak var newCV: UICollectionView!
    @IBOutlet weak var comedyCV: UICollectionView!
    @IBOutlet weak var foodCV: UICollectionView!
    @IBOutlet weak var fitnessCV: UICollectionView!
    @IBOutlet weak var hobbyCV: UICollectionView!
    @IBOutlet weak var travelCV: UICollectionView!
    @IBOutlet weak var nsfwCV: UICollectionView!
    
    
    private var listener: ListenerRegistration?
    
    
    private var newPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.newCV.reloadData()
            }
        }
    }
    
    
    private var comedyPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.comedyCV.reloadData()
            }
        }
    }
    
    private var foodPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.foodCV.reloadData()
            }
        }
    }
    
    
    private var fitnessPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.fitnessCV.reloadData()
            }
        }
    }
    
    private var hobbyPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.hobbyCV.reloadData()
            }
        }
    }
    
    private var travelPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.travelCV.reloadData()
            }
        }
    }
    
    private var nsfwPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.nsfwCV.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCV.dataSource = self
        newCV.delegate = self
        comedyCV.dataSource = self
        comedyCV.delegate = self
        foodCV.dataSource = self
        foodCV.delegate = self
        fitnessCV.dataSource = self
        fitnessCV.delegate = self
        hobbyCV.delegate = self
        hobbyCV.dataSource = self
        nsfwCV.dataSource = self
        nsfwCV.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        listener = Firestore.firestore().collection(DatabaseService.photosCollection)
            .addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                    }
                } else if let snapshot = snapshot {
                    let photos = snapshot.documents.map { Photo($0.data())}
                    self?.newPhotos = photos
                }
            })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove() // no longer are we listening for changes from Firebase
    }
    
    
}


extension ExploreVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newCV {
            return newPhotos.count
        } else if collectionView == comedyCV {
            return comedyPhotos.count
        } else if collectionView == foodCV {
            return foodPhotos.count
        } else if collectionView == fitnessCV {
            return fitnessPhotos.count
        } else if collectionView == hobbyCV {
            return hobbyPhotos.count
        } else if collectionView == travelCV {
            return travelPhotos.count
        } else if collectionView == nsfwCV {
            return nsfwPhotos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if collectionView == self.newCV {
            cell.configureCell(for: newPhotos[indexPath.row])
        } else if collectionView == comedyCV {
            cell.configureCell(for: comedyPhotos[indexPath.row])
        } else if collectionView == foodCV {
            cell.configureCell(for: foodPhotos[indexPath.row])
        } else if collectionView == fitnessCV {
            cell.configureCell(for: fitnessPhotos[indexPath.row])
        } else if collectionView == hobbyCV {
            cell.configureCell(for: hobbyPhotos[indexPath.row])
        } else if collectionView == travelCV {
            cell.configureCell(for: travelPhotos[indexPath.row])
        } else if collectionView == nsfwCV {
            cell.configureCell(for: nsfwPhotos[indexPath.row])
        }
        return cell
    }
    
    
    
    
    
}



extension ExploreVC: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    }
    
    
    
    
    
    
}




