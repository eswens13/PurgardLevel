//
//  PurgardView.swift
//  Purgard Level
//
//  Created by Erik Swenson on 2/17/17.
//  Copyright © 2017 ErikSwenson. All rights reserved.
//

import UIKit

class PurgardView: UIView
{
  var level:Int = 0
  
  /// General initializer
  override init(frame:CGRect)
  {
    super.init(frame: frame)
    self.clearsContextBeforeDrawing = true
  }
  
  /// Initializer to persist state
  required convenience init?(coder aDecoder:NSCoder)
  {
    self.init()
  }
  
  /// Function inherited from UIView that actually does the drawing of the tank
  /// and purgard level.
  ///
  /// @param[in] rect   The drawing rectangle for the view.
  ///
  override func draw(_ rect: CGRect)
  {
    // Remove all the old views
    for view in self.subviews
    {
      view.removeFromSuperview()
    }
    
    // Get the current context for drawing
    let context = UIGraphicsGetCurrentContext()
    self.backgroundColor = UIColor.clear
    UIColor.blue.setFill()
    
    // Infer some sizes based on the rectangle allocated to the view.
    var boxDim:CGFloat = 0
    var box:CGRect = CGRect()
    var div:CGFloat = 0
    if rect.height > rect.width
    {
      boxDim = rect.width
      let extra:CGFloat = (rect.height - rect.width) / 2.0
      box = CGRect(x: 0, y: extra, width: boxDim, height: boxDim)
    }
    else
    {
      boxDim = rect.height
      let extra:CGFloat = (rect.width - rect.height) / 2.0
      box = CGRect(x: extra, y: 0, width: boxDim, height: boxDim)
    }
    div = boxDim / 16.0
    
    // Set the coordinates of some important drawing points for the tank.
    let tankUL:CGPoint = CGPoint(x: box.minX + (3.0 * div),
                                 y: box.minY + (5.0 * div))
    let tankBL:CGPoint = CGPoint(x: box.minX + (3.0 * div),
                                 y: box.maxY - (3.0 * div))
    let tankBR:CGPoint = CGPoint(x: box.maxX - (5.0 * div),
                                 y: box.maxY - (3.0 * div))
    let tankUR:CGPoint = CGPoint(x: box.maxX - (5.0 * div),
                                 y: box.minY + (6.0 * div))
    
    // Set the coordinates of some important drawing points for the spout.
    let spoutUL:CGPoint = CGPoint(x: box.maxX - (4.0 * div),
                                  y: box.minY + (6.0 * div))
    let spoutBL:CGPoint = CGPoint(x: box.maxX - (4.0 * div),
                                  y: box.minY + (8.0 * div))
    let spoutBR:CGPoint = CGPoint(x: box.maxX - (3.0 * div),
                                  y: box.minY + (8.0 * div))
    let spoutUR:CGPoint = CGPoint(x: box.maxX - (3.0 * div),
                                  y: box.minY + (5.0 * div))
    
    // Set the coordinates of some important drawing points for the lid.
    let lidUL:CGPoint = CGPoint(x: box.minX + (5.0 * div),
                                y: box.minY + (4.0 * div))
    let lidBL:CGPoint = CGPoint(x: box.minX + (5.0 * div),
                                y: box.minY + (5.0 * div))
    let lidBR:CGPoint = CGPoint(x: box.maxX - (7.0 * div),
                                y: box.minY + (5.0 * div))
    let lidUR:CGPoint = CGPoint(x: box.maxX - (7.0 * div),
                                y: box.minY + (4.0 * div))
    
    // Set the coordinates of some important points for the tank fill.
    let topOfTank:CGFloat = box.minY + (6.0 * div)
    let fillBottom:CGFloat = box.maxY - (3.0 * div) - 2.0
    let maxFillHeight:CGFloat = fillBottom - topOfTank
    let fillHeight:CGFloat = (CGFloat(self.level) / 100.0) * maxFillHeight
    
    let fillUL:CGPoint = CGPoint(x: box.minX + (3.0 * div) + 2.0,
                                 y: fillBottom - fillHeight)
    let fillBL:CGPoint = CGPoint(x: box.minX + (3.0 * div) + 2.0,
                                 y: fillBottom)
    let fillBR:CGPoint = CGPoint(x: box.maxX - (5.0 * div) - 2.0,
                                 y: fillBottom)
    let fillUR:CGPoint = CGPoint(x: box.maxX - (5.0 * div) - 2.0,
                                 y: fillBottom - fillHeight)
    
    // Draw the outline of the tank and spout.
    context?.setStrokeColor(UIColor.black.cgColor)
    context?.setFillColor(UIColor.black.cgColor)
    context?.setLineWidth(2.0)
    context?.beginPath()
    
    context?.move(to: tankUL)
    context?.addLine(to: tankBL)
    context?.addLine(to: tankBR)
    context?.addLine(to: tankUR)
    context?.addLine(to: spoutUL)
    context?.addLine(to: spoutBL)
    context?.addLine(to: spoutBR)
    context?.addLine(to: spoutUR)
    context?.addLine(to: tankUL)
    context?.drawPath(using: .stroke)
    
    // Draw the filled in lid.
    context?.beginPath()
    context?.move(to: lidUL)
    context?.addLine(to: lidBL)
    context?.addLine(to: lidBR)
    context?.addLine(to: lidUR)
    context?.addLine(to: lidUL)
    context?.drawPath(using: .fillStroke)
    
    // Add a subview to the tank to inidicate Purgard level.
    let fillView:UIView = UIView(frame: CGRect(x: fillUL.x,
                                               y: fillUL.y,
                                               width: fillUR.x - fillUL.x,
                                               height: fillBL.y - fillUL.y))
    fillView.backgroundColor = UIColor.blue
    self.addSubview(fillView)
    
    self.setNeedsDisplay()
  }
  
  /// Updates the purgard level and tells the UI that it needs to be re-drawn.
  ///
  /// @param[in] level  The new level of purgard in the tank as a percentage
  ///                   (0 - 100).
  ///
  func updateLevel(_ level:Int)
  {
    self.level = level
    self.setNeedsDisplay()
  }
}
