//
//  OnboardingPageViewController.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import Foundation
import UIKit
import SwiftUI

struct OnboardingPageViewController: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        
        var parent: OnboardingPageViewController
        init(_ pageViewController: OnboardingPageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.viewControllers.firstIndex(of: viewController), index > 0 else {
                return nil
            }
            
            return parent.viewControllers[index - 1]
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.viewControllers.firstIndex(of: viewController), index + 1 < parent.viewControllers.count else {
                return nil
            }

            return parent.viewControllers[index + 1]
        }
    }
    
    var viewControllers: [UIViewController]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
    }
}
