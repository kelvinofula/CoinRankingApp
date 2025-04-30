//
//  TabBar.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit

class TabBar: UIView {
    
    var selectedIndex: Int = 0
    var btnAction: (() -> Void)?
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpProperties()
        setupHierarchy()
        setUpAutoLayout()
        setupButtons()
    }
    
    convenience init(selectedIndex: Int? = 0) {
        self.init(frame: .zero)
        self.selectedIndex = selectedIndex ?? 0
    }
    
    private func setUpProperties() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)
        
        separatorView.backgroundColor = .lightGray
    }
    
    func applyEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if selectedIndex == 1 {
            subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        } else {
            addSubview(blurEffectView)
            sendSubviewToBack(blurEffectView)
        }
    }
    
    private func setupHierarchy() {
        addSubview(separatorView)
        addSubview(btnsStackView)
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            btnsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            btnsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            btnsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            btnsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupButtons() {
        btnsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let items = ["Coins", "Favorites"]
        
        for i in 0..<items.count {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnTapped))
            tapGesture.accessibilityHint = "\(i)"
            
            let btnView = UIView()
            btnView.translatesAutoresizingMaskIntoConstraints = false
            btnView.tag = i
            btnView.backgroundColor = UIColor.white.withAlphaComponent(0.0) //transparent
            btnView.isUserInteractionEnabled = true
            btnView.addGestureRecognizer(tapGesture)
            
//            NSLayoutConstraint.activate([
//                btnView.heightAnchor.constraint(equalToConstant: 56)
//            ])
            
            let imgBtn = UIImageView()
            imgBtn.translatesAutoresizingMaskIntoConstraints = false
            imgBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imgBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            let lblBtn = UILabel()
            lblBtn.translatesAutoresizingMaskIntoConstraints = false
            lblBtn.text = items[i]
            lblBtn.font = .systemFont(ofSize: 13, weight: .medium)
            lblBtn.textAlignment = .center
            lblBtn.numberOfLines = 1
            
            btnView.addSubview(imgBtn)
            btnView.addSubview(lblBtn)
            
            NSLayoutConstraint.activate([
                imgBtn.centerXAnchor.constraint(equalTo: btnView.centerXAnchor),
                imgBtn.topAnchor.constraint(equalTo: btnView.topAnchor, constant: 8),
                
                lblBtn.centerXAnchor.constraint(equalTo: btnView.centerXAnchor),
                lblBtn.topAnchor.constraint(equalTo: imgBtn.bottomAnchor, constant: 5),
                lblBtn.leadingAnchor.constraint(equalTo: btnView.leadingAnchor, constant: 10),
                lblBtn.trailingAnchor.constraint(equalTo: btnView.trailingAnchor, constant: -10)
            ])
            
            btnsStackView.addArrangedSubview(btnView)
            
            let isSelected = i == selectedIndex
            let imageName = items[i] == "Coins" ? "centsign.circle" : "star.circle.fill"
            let image = UIImage(systemName: imageName) ?? UIImage()
            
            if isSelected {
                menuSelected(iv: imgBtn, label: lblBtn, image: image)
                if i == 1 {
                    subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
                } else {
                    applyEffect()
                }
            } else {
                menuDeselected(iv: imgBtn, label: lblBtn, image: image)
            }
            
        }
    }
    
    func menuSelected(iv: UIImageView, label: UILabel, image: UIImage) {
        iv.image = image.withRenderingMode(.alwaysTemplate)
        iv.tintImage(color: ORANGE_COLOR)
        label.textColor = ORANGE_COLOR
        label.font = .systemFont(ofSize: 13.0, weight: .heavy)
    }
    
    func menuDeselected(iv: UIImageView, label: UILabel, image: UIImage) {
        iv.image = image.withRenderingMode(.alwaysTemplate)
        iv.tintImage(color: .black)
        label.textColor = .black
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
    }
    
    func selectAction(index: Int) {
        selectedIndex = index
        setupButtons()
        btnAction?()
    }
    
    @objc func btnTapped(_ sender: UITapGestureRecognizer) {
        let index = Int(sender.accessibilityHint ?? "0") ?? 0
        selectAction(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    func tintImage(color: UIColor) {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}
