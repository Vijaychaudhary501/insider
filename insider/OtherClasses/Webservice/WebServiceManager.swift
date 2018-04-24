//
//  WebServiceManager.swift
//  Student_GPA
//
//  Created by VIJAY on 14/03/18.
//  Copyright © 2018 TestDemo. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire


class WebServiceManager: NSObject {
    typealias wscall = (_ data:NSDictionary?,_ error:Error?) ->()
    class func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func callGeneralWebService(WSUrl:String, WSParams:NSDictionary, WSMethod:HTTPMethod, isLoader: Bool,completion:@escaping wscall){
        if Reachability.isInternetAvailable(){
            if isLoader{
                KRProgressHUD.show()
            }
            Alamofire.request(WSUrl, method:WSMethod, parameters: WSParams as? [String: Any], encoding: URLEncoding.default).responseJSON { response in
                    KRProgressHUD.dismiss()
                    print(response)
                    switch response.result{
                    case .success(_):
                        do{
                        let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            completion(dict as! NSDictionary,nil)
                            break
                        }
                        catch{
                            
                        }
                        
                    case .failure(_):
                        completion(nil, response.result.error)
                        break
                    
                    }
                    
            }

            //            Alamofire.request(WSUrl, method:HTTPMethod.post, parameters: WSParams, encoding: .default, headers: nil).responseJSON(completionHandler: { (responseData) in
//                print(responseData)
//            })
//            Alamofire.request(test as! URLRequestConvertible, method:HTTPMethod.post, parameters: WSParams as? [String], encoding: .delete, headers: nil).responseJSON(completionHandler: { (response) in
//                switch response.result {
//                case .success:
//                    print(response)
//                    break
//                case .failure(let error):
//
//                    print(error)
//                }
//            })
            
        }
    }
    class func callParameterUsingMultipartImageUploadWithOut(WSUrl:String, WSParams:NSDictionary, isLoader: Bool,iImgName:UIImage,completion:@escaping wscall){
        if Reachability.isInternetAvailable(){
            if isLoader{
                KRProgressHUD.show()
            }
            Alamofire.request(WSUrl, method:HTTPMethod.post, parameters: WSParams as? [String: Any], encoding: URLEncoding.default).validate().responseJSON { response in
                KRProgressHUD.dismiss()
                print(response)
                switch response.result{
                case .success(_):
                    do{
                        let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        completion(dict as! NSDictionary,nil)
                        break
                    }
                    catch{
                    }
                case .failure(_):
                    completion(nil, response.result.error)
                    break
                }
            }
        }
    }
    class func callVideoUploadWithParameterUsingMultipart(WSUrl:String, WSParams: NSDictionary, isLoader: Bool, iVdoName:String, iVideo:URL,completion:wscall){
        
    }
    class func callImageUploadWithParameterUsingMultipart(WSUrl:String, WSParams: NSDictionary, isLoader: Bool, iImgName:String,iImage:UIImage,completion:@escaping wscall){
        let URL = try! URLRequest(url: WSUrl, method: .post, headers: nil)

        Alamofire.upload(multipartFormData: { (multipart) in
            var imgData = UIImageJPEGRepresentation(iImage.resized(withPercentage: 0.7)!,0.5)
            for (key, value) in WSParams {
                 multipart.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            multipart.append(imgData!, withName: "\(iImgName)", fileName: "file.png", mimeType: "image/jpeg")
        }, with: URL) { (resultencoding) in
            switch resultencoding {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    KRProgressHUD.dismiss()
                    switch response.result{
                    case .success(let suc):
                        do{
                            let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            completion(dict as? NSDictionary,nil)
                            break
                        }
                        catch{
                            
                        }
                    case .failure(let error):
                        completion(nil, response.result.error)
                        break
                    }
                }
            case .failure(let error):
                KRProgressHUD.dismiss()
                completion(nil, error)
                break
            }
        }
    }
    
/*class func callImageUploadWithParameterUsingMultipart(WSUrl:String, WSParams: NSDictionary, isLoader: Bool, iImgName:String,iImage:UIImage,completion:@escaping wscall){
    
    
    /*if Reachability.isInternetAvailable(){
            KRProgressHUD.show()
            var urlRequest = URLRequest(url: URL.init(string: WSUrl)!)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let mimeType = "image/jpeg/png"
            urlRequest.httpMethod = "POST"//HTTPMethod.post.rawValue
            //urlRequest.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type" )
            urlRequest.setValue("multipart/form-data; boundary=\(generateBoundaryString())", forHTTPHeaderField: "Content-Type")
            let body = NSMutableData()
            for (key, value) in WSParams {
                body.appendString(generateBoundaryString())
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(key)\r\n")
                body.appendString("\(value)\r\n")
            }
//            body.appendString(generateBoundaryString())
//            body.appendString("Content-Disposition: form-data; name=\"\(iImgName)\"; filename=\"post_files_.jpg\"\r\n")
//            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
//            body.append(UIImageJPEGRepresentation(iImage, 1.0)!)
//            body.appendString("\r\n");
            body.appendString("--".appending(generateBoundaryString().appending("--")))
            urlRequest.httpBody = body as Data
           
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                
            })
            task.resume()

            
            
            

           /* Alamofire.upload(multipartFormData: { (multipart) in
                let imgData = UIImageJPEGRepresentation(iImage, 1.0)
                for (key, value) in WSParams {
                // multipart.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                 }
                multipart.append(imgData!, withName: "\(iImgName)", fileName: "file.png", mimeType: "image/jpeg")
                  multipart.append(imgData!, withName: "\(iImgName)", fileName: "file.jpg", mimeType: "image/jpeg")
            }, with: url, encodingCompletion: { (encloseResult) in
                switch encloseResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        KRProgressHUD.dismiss()
                        switch response.result{
                        case .success(let suc):
                            do{
                                let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                completion(dict as? NSDictionary,nil)
                                break
                            }
                            catch{
                                
                            }
                        case .failure(let error):
                            completion(nil, response.result.error)
                            break
                        }
                    }
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    completion(nil, error)
                    break
                }
            })*/
            
            
            
            
            
            
            
            
            
            
           /*
            Alamofire.upload(multipartFormData: { (multipartDatForm) in
                let imgData = UIImageJPEGRepresentation(iImage, 1.0)
                multipartDatForm.append(imgData!, withName: "\(iImgName)", fileName: "fileopo.jpg", mimeType: "image/jpeg")
                multipartDatForm.append(imgData!, withName: "\(iImgName)", fileName: "", mimeType: "image/jpg")
            }, to: WSUrl, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        KRProgressHUD.dismiss()
                        switch response.result{
                        case .success(let suc):
                            do{
                                let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                completion(dict as? NSDictionary,nil)
                                break
                            }
                            catch{
                                
                            }
                        case .failure(let error):
                            completion(nil, response.result.error)
                            break
                        }
                    }
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    completion(nil, error)
                    break
                }
            })*/
            
/*            Alamofire.upload(multipartFormData: { (multipartFormData) in
                let imgData = UIImageJPEGRepresentation(iImage, 1.0)
                multipartFormData.append(imgData!, withName: "\(iImgName)", fileName: "fileopo.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imgData!, withName: "\(iImgName)", fileName: "", mimeType: "image/jpg")
            }, to: WSUrl, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        KRProgressHUD.dismiss()
                        switch response.result{
                        case .success(let suc):
                            do{
                                let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                completion(dict as? NSDictionary,nil)
                                break
                            }
                            catch{
                                
                            }
                        case .failure(let error):
                            completion(nil, response.result.error)
                            break
                        }
                    }
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    completion(nil, error)
                    break
                }
            })*/        /*Alamofire.upload(multipartFormData: { <#MultipartFormData#> in
                let imgData = UIImageJPEGRepresentation(iImage, 1.0)
           /* for (key, value) in WSParams {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }*/
            multipartFormData.append(imgData!, withName: "\(iImgName)", fileName: "file.jpg", mimeType: "image/jpeg")
          //  multipartFormData.append(imgData!, withName: "\(iImgName)", fileName: "file.jpg", mimeType: "image/jpeg")
        }, to: WSUrl,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    KRProgressHUD.dismiss()
                    switch response.result{
                    case .success(let suc):
                        do{
                            let dict =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            completion(dict as? NSDictionary,nil)
                            break
                        }
                        catch{
                            
                        }
                    case .failure(let error):
                        completion(nil, response.result.error)
                        break
                    }
                }
            case .failure(let error):
                KRProgressHUD.dismiss()
                completion(nil, error)
                break
            }
            
        })*/
    }*/
    }*/
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
extension UIImage{
func resized(toWidth width: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: CGFloat(ceil(width/size.width * size.height)), height: width)
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
}
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
