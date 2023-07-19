//
//  TransitionAnimator.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let selectedCell = (fromViewController as? MainViewController)?.tableView.indexPathForSelectedRow,
              let cellSnapshot = (fromViewController as? MainViewController)?.tableView.cellForRow(at: selectedCell)?.snapshotView(afterScreenUpdates: false)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.addSubview(cellSnapshot)
        
        let selectedCellFrame = (fromViewController as? MainViewController)?.tableView.rectForRow(at: selectedCell) ?? .zero
        let initialFrame = containerView.convert(selectedCellFrame, from: (fromViewController as? MainViewController)?.tableView)
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.frame = finalFrame
        toViewController.view.alpha = 0
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            cellSnapshot.frame = initialFrame
        }, completion: { _ in
            UIView.animate(withDuration: animationDuration, animations: {
                toViewController.view.alpha = 1
            }, completion: { _ in
                cellSnapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        })
    }
}
