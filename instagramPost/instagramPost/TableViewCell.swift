import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var caption: UILabel!

    @IBAction func likes(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set profile image to circular
        displayImage.layer.cornerRadius = displayImage.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
