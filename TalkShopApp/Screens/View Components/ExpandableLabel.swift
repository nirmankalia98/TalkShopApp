//
//  ExpandableLabel.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

@IBDesignable class ExpandableLabel: UIView {
    
    // MARK: - Public Properties
    var isExpanded: Bool = false {
        didSet {
            toggle()
        }
    }
    @IBInspectable var maxExpandableHeight: CGFloat = 100.0  // Maximum height of the expanded label
    @IBInspectable var numberOfCollapsedLines: Int = 2
    @IBInspectable var animationDuration: TimeInterval = 0.25
    @IBInspectable var text: String = "Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum Lorem Ipsum Descriptum "

    // MARK: - Private Properties
    private let scrollView: UIScrollView
    private let label: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        scrollView = UIScrollView()
        label = UILabel()
        label.text = self.text
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        scrollView = UIScrollView()
        label = UILabel()
        label.text = self.text
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupLabel()
        setupScrollView()
        setupTapGesture()
    }
    
    // MARK: - Setup
    private func setupLabel() {
        label.numberOfLines = numberOfCollapsedLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: scrollView.topAnchor),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gesture Handling
    @objc private func handleLabelTap() {
        isExpanded.toggle()
    }
    
    // MARK: - Toggle State
    private func toggle() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.label.numberOfLines = self.isExpanded ? 0 : self.numberOfCollapsedLines
            self.layoutIfNeeded()
        }) { _ in
            self.updateScrollView()
        }
    }
    
    private func updateScrollView() {
        let labelSize = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size.height = labelSize.height
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: labelSize.height)
        
        if self.isExpanded {
            self.scrollView.isScrollEnabled = labelSize.height > self.maxExpandableHeight
            self.scrollView.showsVerticalScrollIndicator = self.scrollView.isScrollEnabled
            if self.scrollView.isScrollEnabled {
                self.scrollView.frame.size.height = self.maxExpandableHeight
            } else {
                self.scrollView.frame.size.height = labelSize.height
            }
        } else {
            self.scrollView.isScrollEnabled = false
            self.scrollView.showsVerticalScrollIndicator = false
        }
    }

    // MARK: - Content Configuration
    func setText(_ text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollView()
    }
}

