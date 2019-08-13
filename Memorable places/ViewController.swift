//
//  ViewController.swift
//  Memorable places
//
//  Created by IMCS2 on 8/10/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var annotationArray: [MKPointAnnotation] = []
    var flag = 0
    var mapArray: [NSManagedObject] = []
    var recieveData:MKPointAnnotation = MKPointAnnotation()
    @IBOutlet weak var myBarButton: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    let segueIdentifier = "SegueToTable"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? TableViewController 
        {
            destination.displayArray = annotationArray
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.addAnnotation(recieveData as MKAnnotation)
        if flag == 0 {
            fetchFromCoreData()
        }
        let uiLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gestureRecognizer:)))
        uiLongPress.minimumPressDuration = 2.0
        map.addGestureRecognizer(uiLongPress)
    }
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.map)
        let coordinates = map.convert(touchPoint, toCoordinateFrom: self.map)
        let annotation = MKPointAnnotation()
        let alert = UIAlertController(title: "Location Name", message: "Enter Location Name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            annotation.title = textField.text!
            self.annotationArray.append(annotation)
            annotation.subtitle = "Long Press Gesture"
            annotation.coordinate = coordinates
            self.save(title: annotation.title! ,longitude: annotation.coordinate.longitude  ,latitude: annotation.coordinate.latitude)
            }))
        self.present(alert, animated: true, completion: nil)
        map.addAnnotation(annotation)
    }
    func save(title: String, longitude: Double , latitude: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MapLocation", in: managedContext)!
        let map = NSManagedObject(entity: entity, insertInto: managedContext)
        map.setValue(title, forKeyPath: "title")
        map.setValue(latitude,forKeyPath: "latitude")
        map.setValue(longitude,forKeyPath: "longitude")
        
        do {
            try managedContext.save()
            mapArray.append(map)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchFromCoreData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MapLocation")
        do {
            mapArray = try managedContext.fetch(fetchRequest)
            for map in mapArray{
                let annotation = MKPointAnnotation()
                annotation.title = map.value(forKeyPath: "title") as? String
                annotation.coordinate.latitude = (map.value(forKeyPath: "latitude") as? Double)!
                annotation.coordinate.longitude = (map.value(forKeyPath: "longitude") as? Double)!
                self.annotationArray.append(annotation)
                self.map.addAnnotation(annotation)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}




