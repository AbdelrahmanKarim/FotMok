//
//  PageViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 30/05/2026.
//

import UIKit

class PageViewController: UIPageViewController {
    var viewControllerArray = [UIViewController]()
    var pageControl : UIPageControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "footballScreen")
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "basketballScreen")
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "tennisScreen")
        guard let v1 = v1 else {return}
        guard let v2 = v2 else {return}
        guard let v3 = v3 else {return}
        viewControllerArray.append(v1)
        viewControllerArray.append(v2)
        viewControllerArray.append(v3)
        if let v1 = viewControllerArray.first{
            setViewControllers([v1], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
        addPageControl()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addPageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY-100, width: UIScreen.main.bounds.width, height: 100))
        pageControl?.currentPage = 0
        pageControl?.numberOfPages = viewControllerArray.count
        pageControl?.pageIndicatorTintColor = .black
        pageControl?.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl!)
        
    }
    


}
extension PageViewController : UIPageViewControllerDelegate , UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIndex = viewControllerArray.index(of: viewController) else {return nil}
        let prevIndex = currIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        return viewControllerArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIndex = viewControllerArray.index(of: viewController) else {return nil}
        let nextIndex = currIndex + 1
        guard nextIndex < viewControllerArray.count else {
            return nil
        }
        return viewControllerArray[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl?.currentPage = viewControllerArray.firstIndex(of: pageContentViewController)!
    }
}
