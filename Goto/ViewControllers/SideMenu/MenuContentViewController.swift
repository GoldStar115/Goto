//
//  MenuContentViewController.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher
class MenuContentViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let arrayMenuItems = ["Payment", "Your Rides", "Referrals", "Help", "Settings", "Log out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.borderColor = UIColor.gray.cgColor
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.masksToBounds = true
        if let strProfileURL = SessionManager.shared.user?.profilePhoto, let url = URL(string: strProfileURL) {
            imgProfile.kf.setImage(with: url)
        }
        lblName.text = ""
        if let firstName = SessionManager.shared.user?.firstName {
            lblName.text = firstName
            if let lastName = SessionManager.shared.user?.lastName {
                lblName.text = firstName + " " + lastName
            }
        } else if let lastName = SessionManager.shared.user?.lastName {
            lblName.text = lastName
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if let lblTitle = cell.viewWithTag(1) as? UILabel {
            lblTitle.text = arrayMenuItems[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sideMenuController?.toggle()
        switch indexPath.row {
        case 0:
//            sideMenuController?.performSegue(withIdentifier: "showSignup", sender: nil)
            break
        case 1:
//            sideMenuController?.performSegue(withIdentifier: "showCardInfo", sender: nil)
            break
        case 5:
            SessionManager.shared.logout()
            break
        default:
            break
        }
    }
}
