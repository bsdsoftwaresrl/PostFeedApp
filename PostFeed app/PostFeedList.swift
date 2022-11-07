
import UIKit
import Alamofire
import Foundation


class PostFeedListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tv: UITableView!
    var posts : [Post] = []
                 
    let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI2MGVkM2EwOS0yNDc3LTQ5MWMtYTA5NS02MzZjOWNhZTAwY2UiLCJnaXZlbl9uYW1lIjoiVm9qa28iLCJmYW1pbHlfbmFtZSI6IiIsIlVzZXJSb2xlIjoidXNlciIsImF1dGhUeXBlIjoiY3VzdG9tIiwibSI6IjlydjlMQitadHIwdFdoU004dkR0WEU3ajJWSDFRRGNjTWg4MzY5ZEkwZ3g4ejBYS1l2TkFGNnRMQUhvODZMdWwiLCJodHRwczovL2NvdW50cnkiOiJSUyIsIlRhdGF0dURiVXNlcklkIjoiNjJjZWM1NjMzZjc5MGU5OThjZWQzNWE2IiwibmJmIjoxNjY3NzQwNjU3LCJleHAiOjE2Njc5MTM0NTcsImlhdCI6MTY2Nzc0MDY1NywiaXNzIjoiaHR0cHM6Ly9zZXJ2aWNlcy1kZXYudGF0YXR1LmNvbS8iLCJhdWQiOiJodHRwczovL3NlcnZpY2VzLWRldi50YXRhdHUuY29tLyJ9.OOs5QQBT79-xqZDi7ezACgCtjZpXDV16eqyAUIQHbysybyUTEiL_qK45zhAENEjDCKL4uwrCQlgWqsOvCki_ihfXIIH43ywelJ00b8Zc9YrM3UVamZKt0uvioqRyz6Do42wkhKjGH0GLC6GSfYUfdvHAU7KytVr5fNGweuPWr9nuwcrJ5MtYaUpAr-JIz9mCGLQZxMkE05fsUO-mJREhM7yfKpzhkkbBNolLcJs09o8qCFxfisrpBKhuYtxygPdf-XIqiFUIVFgeRZlG1TxcehTKWdrTvUIYTrXNxeBwPQSZD_aeKTRAUwK1kKkMHJRmLQJc7AsRCyVXN4mmP-mccA"
        
    var url = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home?skip=0&limit=20"
    let CELL_ID = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
        tv.delegate = self
        
        //get call
        let headers: HTTPHeaders = [.authorization(bearerToken: token as String)]
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        request.validate().response { (response) in
            if let responseValue = try? response.result.get() {
                var responseDict = [String:Any]()
                responseDict["result"] = responseValue
                let data = responseValue as NSData
                let decodedString = String.init(data: (data as Data), encoding: String.Encoding.utf8)
                let dataString = decodedString?.data(using: String.Encoding.utf8)
                do {
                    let dict = try JSONSerialization.jsonObject(with: dataString!, options: .mutableContainers) as! Dictionary<String,Any>
                    if let json = dict as? Dictionary<String,Any> {
                        if(dict["statusCode"] as! Int == 200){
                            if let dictArray = json["result"] as? [Dictionary<String, Any>] {
                                for elem in dictArray {
                                    self.posts.append(Post(json: elem))
                                }
                                
                                //check if some array contains no-image content
                                self.posts = self.posts.filter {
                                    return isAllImages(images: $0.images)
                                }
                                self.tv.reloadData()
                                self.tv.dataSource = self
                            }
                        }
                    } else {
                        let customError = NSError(domain: "", code: 0, userInfo: dict)
                        print(customError)
                    }
                } catch {
                    print("Response error: ", error)
                }
            } else {
                print("Response error: ", response)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! PostCell
        cell.initialize(post: self.posts[indexPath.row])
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
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblDate.text = ""
        self.lblLikes.text = ""
        self.lblAuthor.text = ""
    }
    
    func initialize(post: Post) {
        img.image = #imageLiteral(resourceName: "placeholder.jpeg")
        img.contentMode = .scaleAspectFit
        img.load(URLAddress: post.images[0])
                        
        lblAuthor.text = "Author: " + post.author
        lblLikes.text = "Likes: " + "\(post.likes)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        lblDate.text = "Date: " + dateFormatter.string(from: post.date)
    }
}

class Post: NSObject {
    var author: String = ""
    var date: Date = Date()
    var likes: Int = 0
    var images: [String] = []
    
    override init(){
        self.author = ""
        self.date = Date()
        self.likes = 0
        self.images = []
    }
    
    init(json : Dictionary<String, Any>) {
        
        //date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate : String = json["date"] as! String
        strDate = String(strDate.prefix(10))
        self.date = dateFormatter.date(from: strDate) ?? Date()
        
        //author
        if let user = json["user"] as? Dictionary<String,Any> {
            //print("author: ", user["name"] ?? "")
            self.author = user["name"] as? String ?? ""
        }
        
        //likes
        if let likes = json["reactions"] as? Dictionary<String,Any> {
            //print("likes: ", likes["likesCount"] ?? "")
            self.likes = likes["likesCount"] as? Int ?? 0
        }
        
        //manca da salvare l'array dei contenuti
        if let contentArray = json["mediaItems"] as? [Dictionary<String,Any>] {
            for content in contentArray {
                //print("content: ", content["mediaEndpoint"] ?? "")
                self.images.append(content["mediaEndpoint"] as? String ?? "")
            }
        }
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
