import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var activities: [ActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    func fetchData() {
        activities = PersistentStorage.shared.retrieveData()
        
        activities.reverse()
        tableView.reloadData()
    }

    
    func createPost(postedByName: String, postedByDP: Data, postImg: Data, caption: String, id: Int) {
        PersistentStorage.shared.createData(
            postedByName: postedByName,
            postedByDP: postedByDP,
            postImg: postImg,
            caption: caption,
            date: Date(),
            id: id
        )
        fetchData()
    }
    
    
    
    @IBAction func liked(_ sender: Any) {
        let activitiesTempData1 = PersistentStorage.shared.retrieveData()
        activities = activitiesTempData1.filter({$0.liked == true})
        
        tableView.reloadData()
    }
    
     @IBAction func refreshData(_ sender: Any) {
         fetchData()
     }
    
    @IBAction func addPos(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let secondVC = sb.instantiateViewController(identifier: "ViewController2") as! ViewController2
        secondVC.tappedImageView = sender as? UIImageView
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func savedPosts(_ sender: Any) {
        let activitiesTempData = PersistentStorage.shared.retrieveData()
        activities = activitiesTempData.filter({$0.saved == true})
        
        tableView.reloadData()
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Instagram Clone"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Copyright © 2021 Instagram Clone"
    }
    
    
    //priority
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
     */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

        let activity = activities[indexPath.row]
        
        cell.username.text = activity.postedByName
        cell.caption.text = activity.caption
        cell.date.text = DateFormatter.localizedString(from: activity.date, dateStyle: .medium, timeStyle: .none)
        cell.displayImage.image = UIImage(data: activity.postedByDP)
        cell.contentImage.image = UIImage(data: activity.postImg)
        
        
        if activity.liked{
            cell.likesBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)}
        else {
            cell.likesBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        

        
        if activity.saved {
            cell.saveImageBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        else {
            cell.saveImageBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        cell.likedPosts = {
            PersistentStorage.shared.updateData(id: activity.id, savedStatus: false, likedStatus: true, isSave: false, isLike: true)
        
            
            self.fetchData()
        }
        
            //save button action
        cell.saveButtonAction = {
            PersistentStorage.shared.updateData(id: activity.id, savedStatus: true, likedStatus: false, isSave: true, isLike: false)

            self.fetchData()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
