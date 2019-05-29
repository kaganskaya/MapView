//
//  ViewController.swift
//
//  Created by liza_kaganskaya 
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var but: UIBarButtonItem!
    
    @IBOutlet weak var detailView: DetailView!
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchField = UISearchController(searchResultsController: nil)
        searchField.searchBar.delegate = self
        present(searchField, animated: true , completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let annView = view.annotation
        
        detailView.isHidden = false
        
        detailView.lat = (annView?.coordinate.latitude)!
        
        detailView.long = (annView?.coordinate.longitude)!
        
        detailView.imageUrl = "https://colinbendell.cloudinary.com/image/upload/c_crop,f_auto,g_auto,h_350,w_400/v1512090971/Wizard-Clap-by-Markus-Magnusson.gif"
        
        detailView.show()
        
        
        self.navigationController?.view.didAddSubview(detailView)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        pin.canShowCallout = true
        
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return pin
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //ignore user
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity action
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        activityIndicator.center  = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search field
        
        searchBar.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        
        //search request
        
        let serachRequest = MKLocalSearch.Request()
        
        serachRequest.naturalLanguageQuery = searchBar.text
        
        let request = MKLocalSearch(request: serachRequest)
        
        request.start { (response,error) in
            
            activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                
                print("No data found")
                
            }else{
                
                //removing annotations
                
                let annotations = self.myMap.annotations
                
                self.myMap.removeAnnotations(annotations)
                
                
                //getting city coordinates
                
                let longitude = response?.boundingRegion.center.longitude
                
                let lattitude = response?.boundingRegion.center.latitude
                
                
                //anotation (pin)
                
                let annotation = MKPointAnnotation()
                
                annotation.title = searchBar.text
                
                annotation.subtitle = "Hello \(searchBar.text!)"
                
                annotation.coordinate = CLLocationCoordinate2DMake(lattitude!,longitude!)
                
                self.myMap.addAnnotation(annotation)
                
                
                //zooming
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lattitude!, longitude!)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
                
                let region = MKCoordinateRegion(center: coordinate,span: span)
                
                self.myMap.setRegion(region, animated: true)
                
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.detailView.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.isHidden = true
    }
    
    
}

