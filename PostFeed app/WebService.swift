//
//  WebService.swift
//  PostFeed app
//
//  Created by Jean Paul Elleri on 03/11/22.
//

import Alamofire



private let sharedWebService = WebService()

class WebService: NSObject {
    
    class var sharedInstance: WebService {
        return sharedWebService
    }
    
    fileprivate let WEB_SERVICE_URL = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home?skip=0&limit=20"
    
    fileprivate func postToMethod (_ methodName: String, version: String, params:Dictionary<String,Any>?, entryPoint:String = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home?skip=0&limit=20") {
        var dictionary = Dictionary<String,Any>()
        if params != nil {
            dictionary = params!
        }
        
        let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI2MGVkM2EwOS0yNDc3LTQ5MWMtYTA5NS02MzZjOWNhZTAwY2UiLCJnaXZlbl9uYW1lIjoiVm9qa28iLCJmYW1pbHlfbmFtZSI6IiIsIlVzZXJSb2xlIjoidXNlciIsImF1dGhUeXBlIjoiY3VzdG9tIiwibSI6IjlydjlMQitadHIwdFdoU004dkR0WEU3ajJWSDFRRGNjTWg4MzY5ZEkwZ3g4ejBYS1l2TkFGNnRMQUhvODZMdWwiLCJodHRwczovL2NvdW50cnkiOiJSUyIsIlRhdGF0dURiVXNlcklkIjoiNjJjZWM1NjMzZjc5MGU5OThjZWQzNWE2IiwibmJmIjoxNjY2OTU1MzA2LCJleHAiOjE2NjcxMjgxMDYsImlhdCI6MTY2Njk1NTMwNiwiaXNzIjoiaHR0cHM6Ly9zZXJ2aWNlcy1kZXYudGF0YXR1LmNvbS8iLCJhdWQiOiJodHRwczovL3NlcnZpY2VzLWRldi50YXRhdHUuY29tLyJ9.Dq76uX2SRFk275HfshpZAeF5R67IYec_LQQJvlgXrVDJlhpjLlI9RSx77L1MUcnzMlKslwbCUPWS5Tv3nJ8DIM2j4IxCFIMarP0vmxbMHBM_-89L2b9uk8Vtc7VihOMm_3ZfNnQvHEzWsYU_MK2rkLDiqEN08hcgEv3VW7trY_veYyCMEXPW6Mnad-0LycuhqYtcZXaeYM2MRigYaRt3kP7hvQ_M70_DdjjoDbZ6mzorDMF6qRvZ39BkMwN3B9XsglvbzpD5llshKUlTqctRrwzzfKf_bk5xWGMPU-ocIvEwmMcpp5v6l89Hyyrs7_5goT3E54jyf3_E_cYuxAkIYg"
        
        print(dictionary)
        
        var url = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home?skip=0&limit=20"
        let headers: HTTPHeaders = [.authorization(bearerToken: dictionary["token"] as! String)]
            
        let request = AF.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: headers)
        print (url)
        
        request.validate().response { (response) in
            if let responseValue = try? response.result.get() {
                var responseDict = [String:Any]()
                responseDict["result"] = responseValue
                let data = responseValue as NSData
                let decodedString = String.init(data: (data as Data), encoding: String.Encoding.utf8)
                let dataString = decodedString?.data(using: String.Encoding.utf8)
                do {
                    let dict = try JSONSerialization.jsonObject(with: dataString!, options: .mutableContainers) as! Dictionary<String,Any>
                    if dict["resultCode"] == nil || dict["resultCode"] as? Int == 0 {
                        //tutto ok
                    } else {
                        let customError = NSError(domain: "", code: 0, userInfo: dict)
                        print("error")

                    }
                } catch {
                    print("error")
                }
            } else {
                print("error")
            }
        }
    }
}
