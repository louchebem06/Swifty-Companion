//
//  GraphView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 01/12/2022.
//

import SwiftUI

class Graph {
    var nb: Int;
    
    init(_ nb: Int) {
        self.nb = nb;
    }
    
    func getX() -> CGFloat {
        return (0);
    }
    
    func getY() -> CGFloat {
        return (0);
    }
}

struct GraphView: View {
    let skills: [Skill];
    var graph: Graph;
    
    init(skills: [Skill]) {
        self.skills = skills;
        graph = Graph(skills.count);
    }
    
    var body: some View {
        ZStack {
            ForEach(skills) { skill in
                Text(skill.name).offset(x: graph.getX(), y: graph.getY());
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(skills: [
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0),
            Skill(name: "First", level: 1.0),
            Skill(name: "Second", level: 1.0)
        ])
    }
}
