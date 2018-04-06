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
    
    class func callGeneralWebService(WSUrl:String, WSParams:NSDictionary, WSMethod:HTTPMethod, isLoader: Bool,completion:@escaping wscall){
        if Reachability.isInternetAvailable(){
            if isLoader{
                KRProgressHUD.show()
            }
            Alamofire.request(WSUrl, method:WSMethod, parameters: WSParams as? [String: Any], encoding: URLEncoding.default).validate().responseJSON { response in
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
         if Reachability.isInternetAvailable(){
            KRProgressHUD.show()
        Alamofire.upload(multipartFormData: { multipartFormData in
                let imgData = UIImagePNGRepresentation(iImage)
                multipartFormData.append(imgData!, withName: "\(iImgName)", fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in WSParams {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
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
            
        })
    }
    }
}
