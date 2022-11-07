
import UIKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
    let CELL_ID = "CELL_ID"
    var post: Post = Post()
    
    private var cv : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
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
        post.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! PostImgCell

        cell.image = self.post.images[indexPath.row]
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
    var image: String? {
        didSet {
            guard let data = image else {return}
            bg.load(URLAddress: data)
        }
    }
    
    fileprivate var bg: UIImageView = {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bg.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




