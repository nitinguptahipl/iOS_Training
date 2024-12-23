import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var likesBtn: UIButton!

    var saveButtonAction: (() -> ())?
    var likedPosts: (() -> ())?
    
    @IBAction func likes(_ sender: Any) {
        likedPosts!()
    }
    
    @IBAction func save(_ sender: Any) {
        saveButtonAction!()
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
