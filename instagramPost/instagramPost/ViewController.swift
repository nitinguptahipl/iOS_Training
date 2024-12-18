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

        fetchData()
    }

    func fetchData() {
        activities = PersistentStorage.shared.retrieveData()
        tableView.reloadData()
    }

    
    func createPost(postedByName: String, postedByDP: Data, postImg: Data, caption: String) {
        PersistentStorage.shared.createData(
            postedByName: postedByName,
            postedByDP: postedByDP,
            postImg: postImg,
            caption: caption,
            date: Date()
        )
        fetchData()
    }
    
    @IBAction func addPos(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController2")
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

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

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
