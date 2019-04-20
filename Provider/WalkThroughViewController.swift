//
//  WalkThroughViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIPageViewController {
    
    
    private var walkThroughControllers = [UIViewController]()
    
    private var pageControl = UIPageControl()
    
    private let walkThroughData = [(Constants.string.welCome, Constants.string.walkthroughWelcome),(Constants.string.drive, Constants.string.walkthroughDrive),(Constants.string.earn, Constants.string.walkthroughEarn)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        self.dataSource = self
        self.delegate = self
    }
}

extension WalkThroughViewController {
    
    
    private func initialLoads(){
        
        for i in 0..<walkThroughData.count{

            if let viewCtrl = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.WalkThroughPreviewController) as? WalkThroughPreviewController {
                viewCtrl.set(image: UIImage(named: "walkthrough\(i)"), title: walkThroughData[i].0, description: walkThroughData[i].1)
                self.walkThroughControllers.append(viewCtrl)
            }

        }
        self.setViewControllers([walkThroughControllers[0]], direction: .forward, animated: true, completion: nil)
        let height : CGFloat = 20
        self.pageControl.frame = CGRect(x: 0, y: self.view.frame.height-height*2, width: self.view.frame.width, height: height)
        self.pageControl.numberOfPages = self.walkThroughControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.backgroundColor = .black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.numberOfPages = walkThroughControllers.count
        self.view.addSubview(pageControl)
    }
    
    
}


extension WalkThroughViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = walkThroughControllers.index(of: viewController), index > 0 else {
            return nil
        }
        print(#function,index)
        return walkThroughControllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = walkThroughControllers.index(of: viewController), index<self.walkThroughControllers.count-1 else {
            return nil
        }
        print(#function,index)
        return walkThroughControllers[index+1]
        
    }
  
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        
        return self.walkThroughControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
}

