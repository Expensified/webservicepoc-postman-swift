//
//  ViewController.swift
//  PracticeWebserviceApp
//
//  Created by Mukund K Raman on 6/15/20.
//  Copyright © 2020 Secoren Inc. All rights reserved.
//

import UIKit

//MARK: - KEYBOARD DONE OPTION

extension UITextField {
    // Function to create a toolbar and add it to the keyboard
    func addDoneButtonToKeyboard() {
        // Create a toolbar item to store the done button to be added
        let doneToolBar: UIToolbar = UIToolbar(frame:
            CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        )
        
        // Filler element to add space to allow the done button to be indented to the right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Done button to be added as an item to the keyboard to the right of the flexible space
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignFromView))
        
        // Set the items of the done tool bar and add it as an accessory view to the textfields
        doneToolBar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = doneToolBar
    }
    
    // Function to resign from first responder when the done button is clicked
    @objc func resignFromView() {
        self.resignFirstResponder()
    }
}

//MARK: - REGULAR EXPRESSION CLEAN SYNTAX

// Extensions to allow cleaner syntax for using Regular Expressions
extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do { try self.init(pattern: pattern) }
        catch { preconditionFailure("Illegal regular expression: \(pattern)") }
    }
}

//MARK: - MAIN VIEW CONTROLLER

class ViewController: UIViewController {

    //MARK: - DEFINITIONS
    
    // Consists of the color themes used for this application
    let mainColor: UIColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 0.75)
    let secondMainColor: UIColor = UIColor(red: 202/255, green: 219/255, blue: 235/255, alpha: 1)
    let secondColor: UIColor = .white
    
    // Consists of the variables used to store the info from textfields
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    
    // Consists of the variables for the display of CRUD operations
    let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
    
    // Consists of URLSession Object, URL and HTTP POST request for posting
    // http://extendsclass.com/mock/rest/b13252c14ce87bffd292e697bcb363e4/post
    let postURL = URL(string: "http://52.152.234.171:903/add")
    lazy var postRequest = URLRequest(url: postURL!)
    let postSession = URLSession.shared
    
    // Consists of URLSession and URL Object, which is used for retrieving values
    // http://extendsclass.com/mock/rest/b13252c14ce87bffd292e697bcb363e4/get
    let getURL = URL(string: "http://52.152.234.171:903/get")!
    let getSession = URLSession.shared
    
    // Consists of URLSession Object, URL and HTTP PUT request for updating
    // http://extendsclass.com/mock/rest/b13252c14ce87bffd292e697bcb363e4/put
    let putURL = URL(string: "http://52.152.234.171:903/update")
    lazy var putRequest = URLRequest(url: putURL!)
    let putSession = URLSession.shared
    
    // Consists of URLSession Object, URL and HTTP DELETE request for deleting accounts
    // http://extendsclass.com/mock/rest/b13252c14ce87bffd292e697bcb363e4/delete
    let delURL = URL(string: "http://52.152.234.171:903/delete")
    lazy var delRequest = URLRequest(url: delURL!)
    let delSession = URLSession.shared
    
    // Content label for the Create Operation
    var contentCreateLabel: UILabel!
    
    // Consists of variables used for the Read Operation
    var searchField: UITextField!
    var accountLabel: UILabel!
    
    // Consists of variables used for the Update Operation
    var userUpdateField: UITextField!
    var passUpdateField: UITextField!
    var oldPassField: UITextField!
    var newPassLabel: UILabel!
    
    // Consists of variables used for the Delete Operation
    var userDeleteField: UITextField!
    var passDeleteField: UITextField!
    var deleteLabel: UILabel!
    
    //MARK: - VIEW LOADING METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the HTTP POST Request
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Setup the HTTP PUT Request
        putRequest.httpMethod = "PUT"
        putRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Setup the HTTP DELETE Request
        delRequest.httpMethod = "DELETE"
        delRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Call the subsequent methods
        self.setupMainView()
        self.createTextFields()
        self.createSubmitButton()
        self.setupScrollView()
        self.CreateOperation()
        self.ReadOperation()
        self.UpdateOperation()
        self.DeleteOperation()
    }

    override func loadView() {
        super.loadView()
    }
    
    //MARK: - ELEMENT SETUP OPERATIONS
    
    // Method to setup the main view of the application
    func setupMainView() {
        // Create and setup the main label for the application
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        label.text = "Expense Tracker"
        label.textColor = secondColor
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.textAlignment = NSTextAlignment.center;
        label.center = CGPoint(x: self.view.center.x, y: 100)
        self.view.addSubview(label)
        
        // Setup properties for the main view
        self.view.backgroundColor = self.mainColor
    }
    
    // Method to create and setup the textfields for username and password
    func createTextFields() {
        // Create and setup the username text field
        usernameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        usernameTextField.font = UIFont(name: "HelveticaNeue", size: 15)
        usernameTextField.placeholder = "Enter Username"
        usernameTextField.addDoneButtonToKeyboard()
        usernameTextField.layer.cornerRadius = 15
        usernameTextField.backgroundColor = self.secondMainColor
        usernameTextField.textAlignment = NSTextAlignment.center
        usernameTextField.center = CGPoint(x: self.view.center.x, y: 200)
        usernameTextField.textColor = self.mainColor.withAlphaComponent(1)
        self.view.addSubview(usernameTextField)
        
        // Create and setup the password text field
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        passwordTextField.font = UIFont(name: "HelveticaNeue", size: 15)
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.addDoneButtonToKeyboard()
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = self.secondMainColor
        passwordTextField.textAlignment = NSTextAlignment.center
        passwordTextField.center = CGPoint(x: self.view.center.x, y: 280)
        passwordTextField.textColor = self.mainColor.withAlphaComponent(1)
        self.view.addSubview(passwordTextField)
    }
    
    // Method to create and setup the submit button, sending data to the webservice
    func createSubmitButton() {
        let submitButton = UIButton(type: .roundedRect)
        submitButton.layer.cornerRadius = 15
        submitButton.setTitle("Create", for: .normal)
        submitButton.setTitleColor(self.secondColor, for: .normal)
        submitButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        submitButton.center = CGPoint(x: self.view.center.x, y: 360)
        submitButton.backgroundColor = self.mainColor.withAlphaComponent(1)
        submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        submitButton.addTarget(self, action: #selector(sendToWebService), for: .touchUpInside)
        self.view.addSubview(submitButton)
    }
    
    // Method to setup the scroll view used to view the CRUD operations
    func setupScrollView() {
        self.scrollView.contentSize.height = self.scrollView.frame.height*4
        self.scrollView.center = CGPoint(x: self.view.center.x, y: 580)
        self.scrollView.isScrollEnabled = true
        self.view.addSubview(self.scrollView)
    }
    
    //MARK: - CRUD OPERATIONS
    
    // Method to create the view that shows the info sent to the webservice
    func CreateOperation() {
        // Create and setup the UIView for the labels
        let mainView: UIView = UIView(frame: CGRect(x: 0, y: 15, width: 300, height: 200))
        mainView.layer.cornerRadius = 15
        mainView.backgroundColor = self.secondMainColor
        mainView.center = CGPoint(x: self.scrollView.center.x, y: mainView.center.y)
        self.scrollView.addSubview(mainView)
        
        // Create and setup the main label for this UIView
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 15, width: mainView.frame.width, height: 25))
        mainLabel.text = "Account Creation Response"
        mainLabel.textAlignment = NSTextAlignment.center
        mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        mainLabel.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(mainLabel)
        
        // Create and Setup the ScrollView to display the HTTP Response
        let contentScrollView: UIScrollView = UIScrollView(frame: CGRect(x: 15, y: 42, width: mainView.frame.width, height: 150))
        contentScrollView.contentSize.height = 0
        contentScrollView.isScrollEnabled = true
        mainView.addSubview(contentScrollView)
        
        // Create and setup the label to show the account creation response
        contentCreateLabel = UILabel(frame: CGRect(x: 0, y: 50, width: contentScrollView.frame.width-30, height: 50))
        contentCreateLabel.text = "Create an Account above to see results!"
        contentCreateLabel.numberOfLines = 0
        contentCreateLabel.textColor = .darkGray
        contentCreateLabel.textAlignment = NSTextAlignment.center
        contentCreateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        contentScrollView.addSubview(contentCreateLabel)
    }
    
    // Method to create the view that contains the textfield that checks whether a user exists
    func ReadOperation() {
        // Create and setup the UIView for the labels
        let mainView: UIView = UIView(frame: CGRect(x: 0, y: 225, width: 300, height: 200))
        mainView.layer.cornerRadius = 15
        mainView.backgroundColor = self.secondMainColor
        mainView.center = CGPoint(x: self.scrollView.center.x, y: mainView.center.y)
        self.scrollView.addSubview(mainView)
        
        // Create and setup the main label for this UIView
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 15, width: mainView.frame.width, height: 25))
        mainLabel.text = "Search For Account"
        mainLabel.textAlignment = NSTextAlignment.center
        mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        mainLabel.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(mainLabel)
        
        // Create and setup the textfield to allow for searching of username
        searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        searchField.center = CGPoint(x: mainView.frame.width/2, y: 70)
        searchField.font = UIFont(name: "HelveticaNeue", size: 15)
        searchField.placeholder = "Search For Username"
        searchField.addDoneButtonToKeyboard()
        searchField.layer.cornerRadius = 7.5
        searchField.backgroundColor = self.secondColor
        searchField.textAlignment = NSTextAlignment.center
        searchField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(searchField)
        
        // Create and setup the submit button for submitting the data within textfield
        let submitBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        submitBtn.layer.cornerRadius = 7.5
        submitBtn.setTitle("Search", for: .normal)
        submitBtn.setTitleColor(self.secondColor, for: .normal)
        submitBtn.center = CGPoint(x: mainView.frame.width/2, y: 105)
        submitBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        submitBtn.backgroundColor = self.mainColor.withAlphaComponent(1)
        submitBtn.titleLabel?.textAlignment = NSTextAlignment.center
        submitBtn.addTarget(self, action: #selector(getFromWebService), for: .touchUpInside)
        mainView.addSubview(submitBtn)
        
        // Create and setup the account output label that outputs username and password
        accountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: mainView.frame.width-30, height: 70))
        accountLabel.text = ""
        accountLabel.numberOfLines = 0
        accountLabel.textAlignment = NSTextAlignment.center
        accountLabel.textColor = self.mainColor.withAlphaComponent(1)
        accountLabel.center = CGPoint(x: mainView.frame.width/2, y: 155)
        accountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)!
        mainView.addSubview(accountLabel)
    }
    
    // Method to create the view that allows for updating the password by providing
    // the username, old password, and then new password
    func UpdateOperation() {
        // Create and setup the UIView for the labels
        let mainView: UIView = UIView(frame: CGRect(x: 0, y: 435, width: 300, height: 200))
        mainView.layer.cornerRadius = 15
        mainView.backgroundColor = self.secondMainColor
        mainView.center = CGPoint(x: self.scrollView.center.x, y: mainView.center.y)
        self.scrollView.addSubview(mainView)
        
        // Create and setup the main label for this UIView
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 15, width: mainView.frame.width, height: 25))
        mainLabel.text = "Update Password"
        mainLabel.textAlignment = NSTextAlignment.center
        mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        mainLabel.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(mainLabel)
        
        // Create and setup the textfield to retrieve the username
        userUpdateField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
        userUpdateField.center = CGPoint(x: mainView.frame.width/2, y: 60)
        userUpdateField.font = UIFont(name: "HelveticaNeue", size: 12)
        userUpdateField.placeholder = "Enter Username"
        userUpdateField.addDoneButtonToKeyboard()
        userUpdateField.layer.cornerRadius = 7.5
        userUpdateField.backgroundColor = self.secondColor
        userUpdateField.textAlignment = NSTextAlignment.center
        userUpdateField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(userUpdateField)
        
        // Create and setup the textfield to retrieve the current password
        oldPassField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
        oldPassField.center = CGPoint(x: mainView.frame.width/2, y: 85)
        oldPassField.font = UIFont(name: "HelveticaNeue", size: 12)
        oldPassField.placeholder = "Enter Current Password"
        oldPassField.addDoneButtonToKeyboard()
        oldPassField.layer.cornerRadius = 7.5
        oldPassField.isSecureTextEntry = true
        oldPassField.backgroundColor = self.secondColor
        oldPassField.textAlignment = NSTextAlignment.center
        oldPassField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(oldPassField)
        
        // Create and setup the textfield to retrieve the new password
        passUpdateField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
        passUpdateField.center = CGPoint(x: mainView.frame.width/2, y: 110)
        passUpdateField.font = UIFont(name: "HelveticaNeue", size: 12)
        passUpdateField.placeholder = "Enter New Password"
        passUpdateField.addDoneButtonToKeyboard()
        passUpdateField.layer.cornerRadius = 7.5
        passUpdateField.isSecureTextEntry = true
        passUpdateField.backgroundColor = self.secondColor
        passUpdateField.textAlignment = NSTextAlignment.center
        passUpdateField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(passUpdateField)
        
        // Create and setup the submit button to submit the values to the web service
        let submitBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        submitBtn.layer.cornerRadius = 7.5
        submitBtn.setTitle("Update", for: .normal)
        submitBtn.setTitleColor(self.secondColor, for: .normal)
        submitBtn.center = CGPoint(x: mainView.frame.width/2, y: 135)
        submitBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        submitBtn.backgroundColor = self.mainColor.withAlphaComponent(1)
        submitBtn.titleLabel?.textAlignment = NSTextAlignment.center
        submitBtn.addTarget(self, action: #selector(updateWebService), for: .touchUpInside)
        mainView.addSubview(submitBtn)
        
        // Create and setup scrollview for the webservice response
        let contentScrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 152.5, width: mainView.frame.width, height: 40))
        contentScrollView.contentSize.height = 0
        contentScrollView.isScrollEnabled = true
        mainView.addSubview(contentScrollView)
        
        // Create and setup the account output label that outputs username and password
        newPassLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentScrollView.frame.width-30, height: 40))
        newPassLabel.text = ""
        newPassLabel.numberOfLines = 0
        newPassLabel.textAlignment = NSTextAlignment.center
        newPassLabel.textColor = self.mainColor.withAlphaComponent(1)
        newPassLabel.center = CGPoint(x: contentScrollView.frame.width/2, y: newPassLabel.center.y)
        newPassLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        contentScrollView.addSubview(newPassLabel)
    }
    
    // Method to create the view that will allow deletion of accounts by providing username and password
    func DeleteOperation() {
        // Create and setup the UIView for the labels
        let mainView: UIView = UIView(frame: CGRect(x: 0, y: 645, width: 300, height: 200))
        mainView.layer.cornerRadius = 15
        mainView.backgroundColor = self.secondMainColor
        mainView.center = CGPoint(x: self.scrollView.center.x, y: mainView.center.y)
        self.scrollView.addSubview(mainView)
        
        // Create and setup the main label for this UIView
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 15, width: mainView.frame.width, height: 25))
        mainLabel.text = "Delete Account"
        mainLabel.textAlignment = NSTextAlignment.center
        mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        mainLabel.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(mainLabel)
        
        // Create and setup the textfield for retrieving username
        userDeleteField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
        userDeleteField.center = CGPoint(x: mainView.frame.width/2, y: 65)
        userDeleteField.font = UIFont(name: "HelveticaNeue", size: 15)
        userDeleteField.placeholder = "Enter Username"
        userDeleteField.addDoneButtonToKeyboard()
        userDeleteField.layer.cornerRadius = 7.5
        userDeleteField.backgroundColor = self.secondColor
        userDeleteField.textAlignment = NSTextAlignment.center
        userDeleteField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(userDeleteField)
        
        // Create and setup the textfield for retrieving password
        passDeleteField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
        passDeleteField.center = CGPoint(x: mainView.frame.width/2, y: 95)
        passDeleteField.font = UIFont(name: "HelveticaNeue", size: 15)
        passDeleteField.placeholder = "Enter Password"
        passDeleteField.addDoneButtonToKeyboard()
        passDeleteField.layer.cornerRadius = 7.5
        passDeleteField.isSecureTextEntry = true
        passDeleteField.backgroundColor = self.secondColor
        passDeleteField.textAlignment = NSTextAlignment.center
        passDeleteField.textColor = self.mainColor.withAlphaComponent(1)
        mainView.addSubview(passDeleteField)
        
        // Create and setup the submit button to submit the values to the web service
        let submitBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        submitBtn.layer.cornerRadius = 7.5
        submitBtn.setTitle("Delete", for: .normal)
        submitBtn.setTitleColor(self.secondColor, for: .normal)
        submitBtn.center = CGPoint(x: mainView.frame.width/2, y: 125)
        submitBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        submitBtn.backgroundColor = self.mainColor.withAlphaComponent(1)
        submitBtn.titleLabel?.textAlignment = NSTextAlignment.center
        submitBtn.addTarget(self, action: #selector(deleteWebService), for: .touchUpInside)
        mainView.addSubview(submitBtn)
        
        // Create and setup scrollview for the webservice response
        let contentScrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 142.5, width: mainView.frame.width, height: 50))
        contentScrollView.contentSize.height = 0
        contentScrollView.isScrollEnabled = true
        mainView.addSubview(contentScrollView)
        
        // Create and setup the delete label that shows the success/failure of the request
        deleteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentScrollView.frame.width-30, height: 0))
        deleteLabel.text = ""
        deleteLabel.numberOfLines = 0
        deleteLabel.textAlignment = NSTextAlignment.center
        deleteLabel.textColor = self.mainColor.withAlphaComponent(1)
        deleteLabel.center = CGPoint(x: contentScrollView.frame.width/2, y: deleteLabel.center.y)
        deleteLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        contentScrollView.addSubview(deleteLabel)
    }
    
    //MARK: - WEBSERVICE METHODS
    
    // Method to create a POST request to the web service
    @objc func sendToWebService() {
        // Get the username and password from the textfields
        let username: String = usernameTextField.text!
        let password: String = passwordTextField.text!
        
        // Validate the value received from the textfields using regex
        let expression: NSRegularExpression =
        NSRegularExpression("(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._\\$]+(?<![_.])")
        if(!expression.matches(username) || username.isEmpty || !expression.matches(password) || password.isEmpty) {
            let alert: UIAlertController = UIAlertController(
                title: "Invalid Values",
                message: "You have entered an invalid value for username/password, Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Create JSON object from dictionary
        let accountDict = ["username":username, "password":password]
        let accountJSON = try! JSONSerialization.data(withJSONObject: accountDict, options: [])
        
        // Create the upload task and call the task
        let postUploadTask = postSession.uploadTask(with: postRequest, from: accountJSON) { (data, response, error) in
            if let response = response {
                // Print the Data JSON Result
                var dataStr = ""
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString, terminator: "\n\n\n")
                    dataStr = dataString
                }
                
                // Print the POST HTTP response to console
                print("Response from POST Request:")
                print(response, terminator: "\n\n\n")
                
                // Call the code below within the main thread
                // (Modifies the description to fit UI Element)
                DispatchQueue.main.async {
                    var desc = response.description, closingBracket: String.Index = desc.firstIndex(of: "{")!
                    desc = String(desc[desc.firstIndex(of: ">")!...])
                    desc = desc[...closingBracket] + "\n" + desc[closingBracket...]
                    desc.removeAll(where: {$0 == ">"})
                    let superview = self.contentCreateLabel.superview as! UIScrollView
                    superview.contentSize.height = 650
                    self.contentCreateLabel.center = CGPoint(x: superview.frame.width/2, y: self.contentCreateLabel.center.y)
                    self.contentCreateLabel.frame = CGRect(x: 0, y: 0, width: superview.frame.width-30, height: 650)
                    self.contentCreateLabel.textAlignment = NSTextAlignment.natural
                    self.contentCreateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10)!
                    self.contentCreateLabel.text = desc + "\n\nMessage From Web Service:\n" + dataStr
                }
            }
        }
        postUploadTask.resume()
    }
    
    // Method to create a GET request to the web service
    @objc func getFromWebService() {
        let fetchTask = getSession.dataTask(with: getURL) { (data, response, error) in
            // Validate the response from web service
            guard error == nil else { print("An Error Occurred: \n"); print(error!); return }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error", terminator: "\n\n"); return
            }
            guard let mimeType = response?.mimeType, mimeType == "application/json" else {
                print("MIME Type Not Supported (JSON Only)"); return
            }
            
            // Convert the JSON object into a dictionary and send to searchForAccount() method
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let dictionary = json as? [String:Any], let iterable = dictionary["iterable"] as? [[String:String]] {
                    DispatchQueue.main.async {
                        self.searchForAccount(user: self.searchField.text!, json: iterable)
                    }
                }
            }
        }
        fetchTask.resume()
    }
    
    // Method to search for an account from the provided username and update value
    func searchForAccount(user username: String, json dictArr: [[String:String]]) {
        for dict in dictArr {
            if dict["username"] == username {
                let password = dict["password"]!
                self.accountLabel.text = "Username: " + username + "\n" + "Password: " + password
                return
            }
        }
        self.accountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        self.accountLabel.text = "Account Not Found"
    }
    
    // Method to create a PUT request to the web service to update account
    @objc func updateWebService() {
        // Get username, current password, and new password
        let username: String = userUpdateField.text!
        let curr_password: String = oldPassField.text!
        let new_password: String = passUpdateField.text!
        
        // Validate the value received from the textfields using regex
        let expression: NSRegularExpression =
        NSRegularExpression("(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._\\$]+(?<![_.])")
        if(!expression.matches(username) || username.isEmpty || !expression.matches(curr_password)
            || curr_password.isEmpty || !expression.matches(new_password) || new_password.isEmpty) {
            let alert: UIAlertController = UIAlertController(
                title: "Invalid Values",
                message: "You have entered an invalid value for username/old password/new password, Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Create JSON object from dictionary
        let updateDict = ["username":username, "oldPassword":curr_password, "newPassword":new_password]
        let updateJSON = try! JSONSerialization.data(withJSONObject: updateDict, options: [])
        
        // Create the upload task and call the task
        let updateUploadTask = putSession.uploadTask(with: putRequest, from: updateJSON) { (data, response, error) in
            if let response = response {
                // Print the Data JSON Result
                var dataStr = ""
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString, terminator: "\n\n\n")
                    dataStr = dataString
                }
                
                // Print the POST HTTP response to console
                print("Response from POST Request:")
                print(response, terminator: "\n\n\n")
                
                // Call the code below within the main thread
                // (Modifies the description to fit UI Element)
                DispatchQueue.main.async {
                    let superview = self.newPassLabel.superview as! UIScrollView
                    superview.contentSize.height = 80
                    self.newPassLabel.frame.size = CGSize(width: self.newPassLabel.frame.width, height: 80)
                    self.newPassLabel.text = "New Password: " + new_password
                            + "\nResponse from UPDATE request:\n" + dataStr
                }
            }
        }
        updateUploadTask.resume()
    }
    
    // Method to create a DELETE request to the web service to delete account
    @objc func deleteWebService() {
        // Get the username and password from the textfields
        let username: String = userDeleteField.text!
        let password: String = passDeleteField.text!
        
        // Validate the value received from the textfields using regex
        let expression: NSRegularExpression =
        NSRegularExpression("(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._\\$]+(?<![_.])")
        if(!expression.matches(username) || username.isEmpty || !expression.matches(password) || password.isEmpty) {
            let alert: UIAlertController = UIAlertController(
                title: "Invalid Values",
                message: "You have entered an invalid value for username/password, Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Create JSON object from dictionary
        let deleteDict = ["username":username, "password":password]
        let deleteJSON = try! JSONSerialization.data(withJSONObject: deleteDict, options: [])
        
        // Create the upload task and call the task
        let deleteUploadTask = delSession.uploadTask(with: delRequest, from: deleteJSON) { (data, response, error) in
            if let response = response {
                // Print the Data JSON Result
                var dataStr = ""
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString, terminator: "\n\n\n")
                    dataStr = dataString
                }
                
                // Print the POST HTTP response to console
                print("Response from DELETE Request:")
                print(response, terminator: "\n\n\n")
                
                // Call the code below within the main thread
                // (Modifies the description to fit UI Element)
                DispatchQueue.main.async {
                    let superview = self.deleteLabel.superview as! UIScrollView
                    superview.contentSize.height = 80
                    self.deleteLabel.frame.size = CGSize(width: self.newPassLabel.frame.width, height: 80)
                    self.deleteLabel.text = "Deleted Account Successfully!\nResponse from DELETE request:\n" + dataStr
                }
            }
        }
        deleteUploadTask.resume()
    }
}
