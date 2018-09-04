//
//  ConnectionsTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/5/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConnectionsTableViewController: UITableViewController{
    
    let usermodel = UserModel.sharedInstance
    let currentUserID = Auth.auth().currentUser?.uid
    var list: [User] = []
    var list2: [User] = []
    var list3: [User] = []
    var list4 = [String : Double]()
    var list5 = [(key : String , value : Double)]()
    var list6 = [String : Double]()
    var list7 = [(key : String , value : Double)]()
    var list8 = [(key : String, value : Double)]()
    var list9 = [(key : String, value : Double)]()
    var list10 = [[(key : String, value : String)]]()
    var compatibilityKey = [String : String]()
    var selectedIndex = 0
    var filterIndex = 0
    var currentConnections: [[String : String]]?
    
    let myGroup2 = DispatchGroup()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "findCon2")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        usermodel.listAllUsers { (succ) in
            if(succ)
            {
                self.getPossibleConnections { (success) in
                    if(success)
                    {
                        self.getAllUnder25Miles(completion: { (success2) in
                            if(success2)
                            {
                                self.sortUnder25MileByCompatability(completion: { (success3) in
                                    if(success3)
                                    {
                                        self.getDistanceOrderOver25Mile(completion: { (success4) in
                                            if(success4)
                                            {
                                                self.getCompatibilityOver25Miles(completion: { (success5) in
                                                    if (success5)
                                                    {
                                                        print(self.list7)
                                                        print("//////")
                                                        print(self.list8)
                                                        print("///////")
                                                        print(self.list5)
                                                        self.mergeUnderAndOver25Miles()
                                                        self.getAllInfoInOneStructure(completion: { (success6) in
                                                            if(success6)
                                                            {
                                                                self.tableView.reloadData()
                                                            }
                                                        })
                                                        
                                        
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                }
            }
            
        }
        
        
        
        
        
        /*
        
        usermodel.getUnderConnectionsSnapshot(withUID: currentUserID, completion: {(connectionList)
            in
            if (connectionList.count > 0)
            {
                print("connection list greater than zero")
                self.currentConnections = connectionList
                for person in self.currentConnections!
                {
                    for (index,user) in self.list.enumerated()
                    {
                        if(user.key == person["UID"]!)
                        {
                            self.list.remove(at: index)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            
            
        })
        */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return list10.count
        
        /*
        for (index,person) in list.enumerated()
        {
            if(person.key == currentUserID)
            {
                list.remove(at: index)
            }
        }
        return list.count
         */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        for (index,person) in list.enumerated()
        {
            if(person.key == currentUserID)
            {
                list.remove(at: index)
            }
        }
 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionscell", for: indexPath) as! ConnectionsTableViewCell
        
        // Configure the cell...
        cell.backgroundColor = .clear
        
        let personDict = list10[indexPath.row]
        
        var name = ""
        var distance = 0.0
        var compatibiity = 0.0
        var url = ""
        
        for pair in personDict
        {
            if (pair.key == "Name")
            {
                name = pair.value
            }
            else if (pair.key == "Distance")
            {
                distance = Double(pair.value)!
            }
            else if (pair.key == "Compatibility")
            {
                compatibiity = Double(pair.value)!
            }
            else if (pair.key == "URL")
            {
                url = (pair.value)
                print("url: " + url)
            }
            
        }
    
        
        
        cell.datalabel.font = cell.datalabel.font.withSize(14)
        
        let userInfo = "\(name)-\(compatibiity)% Match-\(distance) MI Away"
        cell.datalabel.text = userInfo.uppercased()
        
        
        setImageFromURl(stringImageUrl: (url), forImage: cell.photo)
        cell.photo.layer.masksToBounds = true
        cell.photo.clipsToBounds = true
        cell.photo.layer.cornerRadius = cell.photo.frame.height/2
        cell.photo.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        cell.photo.layer.borderWidth = 2.0
        
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row
        let arrayOfData = list10[selectedIndex]
        var sentUID = ""
        var user: User?
        for pair in arrayOfData
        {
            if pair.key == "UID"
            {
                sentUID = pair.value
            }
        }
        usermodel.returnUserObject(UID: sentUID) { (user) in
            let sentUser = user
            self.performSegue(withIdentifier: "profileInfoSegue", sender: sentUser)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "profileInfoSegue")
        {
            let destinationVC = segue.destination as! StrangerProfileViewController
            destinationVC.thisUser = sender as? User
        }
    }
    
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
        }
    }
    
    /*
    
    func getAllunder25Miles(completion: @escaping (Bool) -> Void)
    {
        list = usermodel.users
        var amountRemoved = 0
        
        for(index, user ) in list.enumerated()
        {
            myGroup.enter()
            if(user.key != currentUserID)
            {
                usermodel.checkIfConnection(meUID: currentUserID!, friendUID: user.key) { (check) in
                    if(check == true)
                    {
                        self.list.remove(at: index)
                        amountRemoved = amountRemoved+1
                        self.myGroup.leave()
                    }
                    else
                    {
                        //self.myGroup2.enter()
                        self.usermodel.distanceBetweenUsers(meUID: self.currentUserID!, otherUID: user.key, completion: { (distance) in
                            if(distance <= 25)
                            {
                                print(user.key + " \(distance)")
                                self.list2.append(user)
                                self.list.remove(at: (index - amountRemoved))
                                amountRemoved = amountRemoved+1
                                self.myGroup.leave()
                            }
                            else
                            {
                                print(distance)
                            }
                            //self.myGroup.leave()
                         
                        })
                       //self.myGroup.leave()
                    }
                    /*
                    self.myGroup2.notify(queue: DispatchQueue.main, execute:{
                        print("group 2 complete")
                        self.myGroup.leave()
                        
                    }) */
                }
            }
            else
            {
                //self.myGroup.leave()
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            completion(true)

        })
    }
 
 */
    
    func getPossibleConnections(completion: @escaping (Bool) -> Void)
    {
        list = usermodel.users
        var amountRemoved = 0
        var arrayOfRemovedIndex = [Int]()
        let myGroup = DispatchGroup()
        
        for(index, user) in list.enumerated()
        {
            print(user.key)
            print(currentUserID)
           
            if(user.key != currentUserID!)
            {
                myGroup.enter()
                usermodel.checkIfConnection(meUID: currentUserID!, friendUID: user.key) { (success) in
                    if(!success)
                    {
                        if(self.filterIndex == 1)
                        {
                            if(user.pref1 == "Yes")
                            {
                                self.list2.append(user)
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            self.list2.append(user)
                        }
                    }
                    myGroup.leave()
                }
            }
            else
            {
                //list.remove(at: index)
                arrayOfRemovedIndex.append(index)
                //myGroup.leave()
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute:
            {
                var amountRemoved = 0
                
                for value in arrayOfRemovedIndex
                {
                    self.list.remove(at: value - amountRemoved)
                    amountRemoved = amountRemoved + 1
                }
                
                for value in self.list.enumerated()
                {
                    print(value)
                }
                completion(true)
            })
    }
    
    func getAllUnder25Miles(completion: @escaping (Bool) -> Void)
    {
        let myGroup = DispatchGroup()
        var amountRemoved = 0
        var arrayOfRemovedIndex = [Int]()
        for (index, user) in list2.enumerated()
        {
            myGroup.enter()
            usermodel.distanceBetweenUsers(meUID: currentUserID!, otherUID: user.key) { (distance) in
                if(distance <= 25)
                {
                    self.list3.append((user as? User)!)
                    amountRemoved = amountRemoved+1
                    arrayOfRemovedIndex.append(index)
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute:
            {
                var amountRemoved = 0
                for value in arrayOfRemovedIndex
                {
                    self.list2.remove(at: value - amountRemoved)
                    amountRemoved = amountRemoved + 1
                }
                completion(true)
        })
    }
    
    func sortUnder25MileByCompatability(completion: @escaping (Bool) -> Void)
    {
        let myGroup = DispatchGroup()
        usermodel.getQuestionairAnswers(UID: currentUserID!) { (meAnswers) in
            
            let compatibility = [String : Double]()
            var mySet = [Int]()
            var cumulativeVal = 0
            for (index, value) in meAnswers.enumerated()
            {
                cumulativeVal = cumulativeVal + (value - 2)
                if((index+1) % 10 == 0)
                {
                    mySet.append(cumulativeVal)
                    cumulativeVal = 0
                }
            }
            
            for user in self.list3
            {
                myGroup.enter()
                self.usermodel.getQuestionairAnswers(UID: user.key) { (questions) in
                    
                    var themSet = [Int]()
                    cumulativeVal = 0
                    for (index, value) in questions.enumerated()
                    {
                        cumulativeVal = cumulativeVal + (value - 2)
                        if((index+1) % 10 == 0)
                        {
                            themSet.append(cumulativeVal)
                            cumulativeVal = 0
                        }
                    }
                    var cumulativeCompat = 0.0
                    for (index,value) in mySet.enumerated()
                    {
                        cumulativeCompat = cumulativeCompat + abs(((Double(themSet[index]) - Double(value))/40.0))
                    }
                    cumulativeCompat = cumulativeCompat * 10
                    cumulativeCompat = round(cumulativeCompat * 10) / 10
                    self.list4[user.key] = cumulativeCompat
                    myGroup.leave()
                }
            }
            myGroup.notify(queue: DispatchQueue.main, execute:
                {
                    self.list5 = self.list4.sorted(by: {$1.value < $0.value})
                    print("Got all compatibility")
                    completion(true)
            })
            
        }
        
    }
    func getDistanceOrderOver25Mile(completion: @escaping (Bool) -> Void)
    {
        let myGroup = DispatchGroup()
        
        
        for (index, user) in list2.enumerated()
        {
            myGroup.enter()
            usermodel.distanceBetweenUsers(meUID: currentUserID!, otherUID: user.key) { (distance) in
                
                self.list6[user.key] = distance
                myGroup.leave()
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute:
            {
                self.list7 = self.list6.sorted(by: {$0.value < $1.value})
                completion(true)
        })
    }
    func getCompatibilityOver25Miles(completion: @escaping (Bool) -> Void)
    {
        let myGroup = DispatchGroup()
        usermodel.getQuestionairAnswers(UID: currentUserID!) { (meAnswers) in
            
            let compatibility = [String : Double]()
            var mySet = [Int]()
            var cumulativeVal = 0
            for (index, value) in meAnswers.enumerated()
            {
                cumulativeVal = cumulativeVal + (value - 2)
                if((index+1) % 10 == 0)
                {
                    mySet.append(cumulativeVal)
                    cumulativeVal = 0
                }
            }
            
            for user in self.list7
            {
                myGroup.enter()
                self.usermodel.getQuestionairAnswers(UID: user.key) { (questions) in
                    
                    var themSet = [Int]()
                    cumulativeVal = 0
                    for (index, value) in questions.enumerated()
                    {
                        cumulativeVal = cumulativeVal + (value - 2)
                        if((index+1) % 10 == 0)
                        {
                            themSet.append(cumulativeVal)
                            cumulativeVal = 0
                        }
                    }
                    var cumulativeCompat = 0.0
                    for (index,value) in mySet.enumerated()
                    {
                        cumulativeCompat = cumulativeCompat + abs(((Double(themSet[index]) - Double(value))/40.0))
                    }
                    cumulativeCompat = cumulativeCompat * 10
                    cumulativeCompat = round(cumulativeCompat * 10) / 10
                    self.list8.append((key: user.key, value: cumulativeCompat))
                    myGroup.leave()
                }
            }
            myGroup.notify(queue: DispatchQueue.main, execute:
                {
                    completion(true)
            })
        }
    }
    func mergeUnderAndOver25Miles()
    {
        for pair in list5
        {
            list9.append(pair)
        }
        for pair in list8
        {
            list9.append(pair)
        }
    }
    func getAllInfoInOneStructure(completion: @escaping (Bool) -> Void)
    {
        for user in list9
        {
            let myGroup = DispatchGroup()
            let mySecondGroup = DispatchGroup()
            var name = ""
            var compatibility = String(user.value)
            var distanceBetween = ""
            var url = ""
            var uid = ""
            myGroup.enter()
            usermodel.distanceBetweenUsers(meUID: currentUserID!, otherUID: user.key) { (distance) in
                distanceBetween = String(distance)
                uid = user.key
                myGroup.leave()
            }
            myGroup.notify(queue: DispatchQueue.main, execute:
            {
                    mySecondGroup.enter()
                    self.usermodel.findUserProfileInfo(uid: user.key, completion: { (info) in
                        name = info["First Name"]! + " " + info["Last Name"]!
                        url = info["Thumb"]!
                        mySecondGroup.leave()
                })
                mySecondGroup.notify(queue: DispatchQueue.main, execute:
                    {
                        var temp = [(key : String, value : String)]()
                        let NamePair = (key : "Name" , value: name)
                        let compatPair = (key : "Compatibility" , value: compatibility)
                        let distancePair = (key : "Distance" , value: distanceBetween)
                        let urlPair = (key : "URL", value: url)
                        let uidPair = (key : "UID", value : uid)
                        temp.append(NamePair)
                        temp.append(compatPair)
                        temp.append(distancePair)
                        temp.append(urlPair)
                        temp.append(uidPair)
                        self.list10.append(temp)
                        completion(true)
                    })
            })
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

