//
//  LabelCell.swift
//  Compositional-Layout-App
//
//  Created by Eric Davenport on 8/17/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {
  
  public lazy var textLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  
  // coming from programmatic UI setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  // coming from Storyboard
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.commonInit()
  }
  
  private func commonInit() {
    textLabelConstraints()
  }
  
  private func textLabelConstraints() {
    // 1
    addSubview(textLabel)
    
    // 2
    // we handle layout using Auto Layout not autoresizing  mask
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // 3
    // setup requires constraints
    NSLayoutConstraint.activate([
      textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
  
  
}
