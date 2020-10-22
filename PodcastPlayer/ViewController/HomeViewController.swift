//
//  HomeViewController.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/22.
//

import UIKit

import SnapKit

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var podcastList: [String] = ["A", "B", "C", "D"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(cellType: HomePageTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HomePageTableViewCell.self, for: indexPath)
        let item = podcastList[indexPath.row]
        cell.cofigure(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 3/5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodePage = EpisodeViewController(podcastList[indexPath.row])
        navigationController?.pushViewController(episodePage, animated: true)
    }
}
