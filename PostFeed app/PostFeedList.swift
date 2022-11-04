//
//  ViewController.swift
//  PostFeed app
//
//  Created by Jean Paul Elleri on 02/11/22.
//

import UIKit
import Alamofire
import Foundation

struct PostData {
    var author: String
    var date: Date
    var likes: Int
    var images: [String]
}

class PostFeedListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tv: UITableView!
    
    //mock
    var posts = [PostData(author: "1 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg","https://picsum.photos/200.jpg","https://picsum.photos/200.jpg","https://picsum.photos/200.jpg",]),
                 PostData(author: "2 title", date: Date(), likes: 0, images: ["https://picsum.photos/200","https://picsum.photos/200",]),
                 PostData(author: "3 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "4 title", date: Date(), likes: 0, images: ["https://picsum.photos/200"]),
                 PostData(author: "6 title", date: Date(), likes: 0, images: ["https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200",]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"]),


                 PostData(author: "7 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg","https://picsum.photos/200",]),
                 PostData(author: "8 title", date: Date(), likes: 0, images: ["https://picsum.photos/200.jpg"])]
    
    let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI2MGVkM2EwOS0yNDc3LTQ5MWMtYTA5NS02MzZjOWNhZTAwY2UiLCJnaXZlbl9uYW1lIjoiVm9qa28iLCJmYW1pbHlfbmFtZSI6IiIsIlVzZXJSb2xlIjoidXNlciIsImF1dGhUeXBlIjoiY3VzdG9tIiwibSI6IjlydjlMQitadHIwdFdoU004dkR0WEU3ajJWSDFRRGNjTWg4MzY5ZEkwZ3g4ejBYS1l2TkFGNnRMQUhvODZMdWwiLCJodHRwczovL2NvdW50cnkiOiJSUyIsIlRhdGF0dURiVXNlcklkIjoiNjJjZWM1NjMzZjc5MGU5OThjZWQzNWE2IiwibmJmIjoxNjY2OTU1MzA2LCJleHAiOjE2NjcxMjgxMDYsImlhdCI6MTY2Njk1NTMwNiwiaXNzIjoiaHR0cHM6Ly9zZXJ2aWNlcy1kZXYudGF0YXR1LmNvbS8iLCJhdWQiOiJodHRwczovL3NlcnZpY2VzLWRldi50YXRhdHUuY29tLyJ9.Dq76uX2SRFk275HfshpZAeF5R67IYec_LQQJvlgXrVDJlhpjLlI9RSx77L1MUcnzMlKslwbCUPWS5Tv3nJ8DIM2j4IxCFIMarP0vmxbMHBM_-89L2b9uk8Vtc7VihOMm_3ZfNnQvHEzWsYU_MK2rkLDiqEN08hcgEv3VW7trY_veYyCMEXPW6Mnad-0LycuhqYtcZXaeYM2MRigYaRt3kP7hvQ_M70_DdjjoDbZ6mzorDMF6qRvZ39BkMwN3B9XsglvbzpD5llshKUlTqctRrwzzfKf_bk5xWGMPU-ocIvEwmMcpp5v6l89Hyyrs7_5goT3E54jyf3_E_cYuxAkIYg"
        
    var url = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home?skip=0&limit=20"
    let CELL_ID = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
        tv.delegate = self
        
        //get call
        /*let headers: HTTPHeaders = [.authorization(bearerToken: token as String)]
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        request.validate().response { (response) in
            if let responseValue = try? response.result.get() {
                print("Response valid: ", response)
                // data
            } else {
                print("Response error: ", response)
            }
        }*/
        
        //check if some array contains no-image content
        posts = posts.filter {
            return isAllImages(images: $0.images)
        }
        
        tv.reloadData()
        tv.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! PostCell
        let dateFormatter = DateFormatter()
        cell.data = self.posts[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: ", self.posts[indexPath.row].author)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "postDetailViewController") as! PostDetailViewController
        vc.post = self.posts[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



class PostCell: UITableViewCell {
    
    var data: PostData? {
        didSet {
            img.image = #imageLiteral(resourceName: "placeholder.jpeg")
            img.contentMode = .scaleAspectFit

            guard let data = data else {return}
            img.load(URLAddress: data.images[0])
            lblAuthor.text = "Author: " + data.author
            lblLikes.text = "Likes: " + "\(data.likes)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            lblDate.text = "Date: " + dateFormatter.string(from: data.date)
        }
    }
    
    var post: PostData?
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}






//download image async
extension UIImageView {
    func load(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

func isAllImages(images : [String]) -> Bool {
    var onlyImages = true
    images.forEach{ image in
        let fileUrl = URL(string: image)
        let urlExtension: String? = fileUrl?.pathExtension
        if(!(urlExtension == "png" || urlExtension == "jpg" || urlExtension == "jpeg")){
            onlyImages = false
        }
    }
    //let supportedTypes:[CFString] = CGImageSourceCopyTypeIdentifiers() as? [CFString] ?? []
    return onlyImages
}
