//
//  Untitled.swift
//  learningCoreData
//
//  Created by HIPLMACBOOK14 on 10/12/24.
//
import CoreData

struct ActivityModel {
    let postedByName: String
    let postedByDP: Data
    let date: Date
    let caption: String
    let postImg: Data
    let saved: Bool
    let liked: Bool
    let id : Int
}



final class PersistentStorage {
    
    static let shared = PersistentStorage()
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "instagramPost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func createData(postedByName: String, postedByDP: Data, postImg: Data, caption: String, date: Date, id: Int) {
        
        let managedContext = viewContext
        
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Activity", in: managedContext)!

            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(postedByDP, forKeyPath: "postedByDP")
            user.setValue(postImg, forKeyPath: "postImg")
            user.setValue(caption, forKeyPath: "caption")
            user.setValue(postedByName, forKeyPath: "postedByName")
            user.setValue(Date(), forKeyPath: "date")
            user.setValue(false, forKeyPath: "saved")
            user.setValue(false, forKeyPath: "liked")
            user.setValue(id, forKeyPath: "id")
            
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save data: \(error), \(error.userInfo)")
        }
    }

    
    func retrieveData() -> [ActivityModel] {
        
        
        let managedContext = viewContext

        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Activity")

        do {
            
            let activities = try managedContext.fetch(fetchRequest)
            
            
            var activityModels: [ActivityModel] = []
            for activity in activities {
                if let postedByName = activity.value(forKey: "postedByName") as? String,
                   let postedByDP = activity.value(forKey: "postedByDP") as? Data,
                   let date = activity.value(forKey: "date") as? Date,
                   let postImg = activity.value(forKey: "postImg") as? Data,
                   //new
                   let saved = activity.value(forKey: "saved") as? Bool,
                   let liked = activity.value(forKey: "liked") as? Bool,
                   let id = activity.value(forKey: "id") as? Int,
                   
                   let caption = activity.value(forKey: "caption") as? String {
                    
                    
                    activityModels.append(ActivityModel(
                        postedByName: postedByName,
                        postedByDP: postedByDP,
                        date: date,
                        caption: caption,
                        postImg: postImg,
                        //new
                        saved: saved,
                        liked: liked,
                        id: id
                    ))
                }
            }
            return activityModels
            
        } catch let error as NSError {
            print("Could not fetch data: \(error), \(error.userInfo)")
            return []
        }
    }
    //get id from table view cell
    func updateData(id: Int, savedStatus: Bool, likedStatus: Bool, isSave: Bool, isLike: Bool) {
        // Get the context from the persistent container
        let managedContext = viewContext
        
        // Create the fetch request for "User" entity, filtering by username
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))


        do {
            // Fetch the user record to update
            let result = try managedContext.fetch(fetchRequest)
            
            if let objectToUpdate = result.first as? NSManagedObject {
                // Modify the attributes of the fetched object
                
                if isSave {
                    objectToUpdate.setValue(savedStatus, forKey: "saved")
                }
                
                if isLike {
                    objectToUpdate.setValue(likedStatus, forKey: "liked")
                }
                
                // Save the updated context
                try managedContext.save()
            }
            
        } catch {
            print("Failed to update data: \(error)")
        }

        
    }
    
}
