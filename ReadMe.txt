/* 
  ReadMe.strings
  SmartZip

  Created by Pawan Kumar on 25/06/16.
  Copyright © 2016 Pawan Kumar. All rights reserved.
*/



https://github.com/Alamofire/Alamofire
Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
.responseJSON { response in
    print(response.request)  // original URL request
    print(response.response) // URL response
    print(response.data)     // server data
    print(response.result)   // result of response serialization
    
    if let JSON = response.result.value {
        print("JSON: \(JSON)")
    }
}
imageView.kf_setImageWithURL(NSURL(string: "http://your_image_url.png")!, placeholderImage: nil)


func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    let textToTranslate = self.textFieldToTranslate.text
    
    let parameters = ["q":textToTranslate,
    "langpair":"en|es"]
    
    Alamofire.request(.GET, "http://api.mymemory.translated.net/get", parameters:parameters)
    .responseJSON { (_, _, JSON, _) -> Void in
        
        let translatedText: String? = JSON?.valueForKeyPath("responseData.translatedText") as String?
        
        if let translated = translatedText {
            self.translatedTextLabel.text = translated
        } else {
            self.translatedTextLabel.text = "No translation available."
        }
        
    }
    
    textField.resignFirstResponder()
    
    return true
}



import SnapKit

class MyViewController: UIViewController {
    
    lazy var box = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(box)
        box.snp_makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }
    
}

