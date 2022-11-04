//
//
//  ViewController.swift
//  PostFeed app
//
//  Created by Jean Paul Elleri on 02/11/22.
//

import UIKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let items = [PostData(author: "1 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "2 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "3 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "4 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "5 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "6 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "7 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"])]
    
    let CELL_ID = "CELL_ID"
    var post: PostData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(cv)
        cv.register(PostImgCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cv.dataSource = self
        cv.delegate = self
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! PostImgCell
        let dateFormatter = DateFormatter()
        cell.data = self.items[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }
}





class PostImgCell: UICollectionViewCell {
    
    var data: PostData? {
        didSet {
            guard let data = data else {return}
            bg.load(URLAddress: data.images[0])
        }
    }
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




