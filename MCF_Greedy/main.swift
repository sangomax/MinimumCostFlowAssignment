//
//  main.swift
//  MCF_Greedy
//
//  Created by Adriano Gaiotto de Oliveira on 2021-04-15.
//

import Foundation

public struct UF {
    /// parent[i] = parent of i
    private var parent: [Int]
    /// size[i] = number of nodes in tree rooted at i
    private var size: [Int]
    /// number of components
    private(set) var count: Int
    
    /// Initializes an empty union-find data structure with **n** elements
    /// **0** through **n-1**.
    /// Initially, each elements is in its own set.
    /// - Parameter n: the number of elements
    public init(_ n: Int) {
        self.count = n
        self.size = [Int](repeating: 1, count: n)
        self.parent = [Int](repeating: 0, count: n)
        for i in 0..<n {
            self.parent[i] = i
        }
    }
    
    /// Returns the canonical element(root) of the set containing element `p`.
    /// - Parameter p: an element
    /// - Returns: the canonical element of the set containing `p`
    public mutating func find(_ p: Int) -> Int {
        var node = p
        while node != parent[node] {
            parent[p] = parent[parent[p]]
            node = parent[node]
        }
        return node
    }
    
    /// Returns `true` if the two elements are in the same set.
    /// - Parameters:
    ///   - p: one elememt
    ///   - q: the other element
    /// - Returns: `true` if `p` and `q` are in the same set; `false` otherwise
    public mutating func connected(_ p: Int, _ q: Int) -> Bool {
        return find(p) == find(q)
    }
    
    /// Merges the set containing element `p` with the set containing
    /// element `q`
    /// - Parameters:
    ///   - p: one element
    ///   - q: the other element
    public mutating func union(_ p: Int, _ q: Int) {
        let i : Int = find(p)
        let j : Int = find(q)
        if i == j { return }
        if size[i] < size[j] {
            parent[i] = j
            size[j] += size[i]
        } else {
            parent[j] = i
            size[i] += size[j]
        }
    }
    
    public mutating func sizeRoot(_ p: Int) -> Int {
        return size[find(p)]
    }
}

struct CompPipe {
    var v: Int
    var w: Int
    var act: Bool
}

extension CompPipe: Comparable {
  public static func <(lhs: CompPipe, rhs: CompPipe) -> Bool {
    return lhs.w < rhs.w
  }
}

extension CompPipe: Hashable {}


func startMCF(_ input: [String.SubSequence], _ ans:  String) -> Int {
//func startMCF() {
    
//        let firstLine = readLine()!.split(separator: " ")
        let firstLine = input[0].split(separator: " ")
        
        let n = Int(firstLine[0])!
        let m = Int(firstLine[1])!
        let d = Int(firstLine[2])!
        
        var pipes = [[(v: Int, w: Int, act: Bool)]](repeating: [], count: n + 1)
        
       
        var pipe1 = [(u: Int, v: Int, w: Int, act: Bool)]()
        
        for i in 0..<m {
            
//            let pipe = readLine()!.split(separator: " ")
            let pipe = input[1 + i].split(separator: " ")
            
            let a = Int(pipe[0])!
            let b = Int(pipe[1])!
            let c = Int(pipe[2])!
            
            var active = false
            if i < n-1 {
                active = true
                if c - d <= 0 {
                    pipe1.append((u: a, v: b, w: c, act: active))
                }
            }
            
            pipes[a].append((v: b, w: c, act: active))
            
        }
        
    //    var days = kruskalMST(pipes, n, m, d)
        
        let (days, _ ) = kruskalMST(pipes, n, m, d)
//        print(days)
    return days
}

public func kruskalMST(_ graph: [[(v: Int, w: Int, act: Bool)]], _ n: Int,_ m: Int,_ d: Int ) -> (Int, [(Int, Int, Int, Bool)])  {
  var allEdges = [(u: Int, v: Int, w: Int, act: Bool)]()
  var mstEdges = [(u: Int, v: Int, w: Int, act: Bool)]()
  
  for (u, node) in graph.enumerated() {
    for edge in node {
        allEdges.append((u: u, v: edge.v, w: edge.w, edge.act))
    }
  }
    
    
  allEdges.sort { $0.w < $1.w || $0.w == $1.w && $0.act == true }
  
  var uf = UF(graph.count)
  for edge in allEdges {
    if uf.connected(edge.u, edge.v) { continue }
    uf.union(edge.u, edge.v)
    mstEdges.append(edge)
  }
    
    var largest = 0
    var index = 0
    var count = 0
    for p in mstEdges {
        if p.2 > largest {
            index = count
            largest = p.2
        }
        count += 1
    }
    
    var largest2 = 0
    var index2 = 0
    var count2 = 0
    for p in allEdges {
        if p.act {
            if p.w > largest2 {
                index2 = count2
                largest2 = p.w
            }
            count2 += 1
        }
    }
    
    
    
    
    var num = mstEdges.map { $0.act == false ? 1 : 0 }.reduce(0, +)
    
    if !mstEdges[index].act {
        if allEdges[index2].w - d <= 0 {
            num -= 1
        }
    }
    
    return (num, mstEdges)
}

//startMCF()


//
var countPass = 0
var countWrong = 0
let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
for i in 1...50 {

//    if i != 33 && i != 36 && i != 39 && i != 40 && i != 44 && i != 45 && i != 33 && i != 49 {
//        continue
//    }

    let fileURLIn = URL(fileURLWithPath: "/Users/adrianogaiotto/Documents/WMAD/ClassFiles/Swift/AlgorithmsDataStructures/AlgorithmsDataStructures/Assignments/MCF/mcf/mcf.\(i).in", relativeTo: directoryURL)

    let fileURLOut = URL(fileURLWithPath: "/Users/adrianogaiotto/Documents/WMAD/ClassFiles/Swift/AlgorithmsDataStructures/AlgorithmsDataStructures/Assignments/MCF/mcf/mcf.\(i).out", relativeTo: directoryURL)

    var input = [String.SubSequence]()
    var result = ""
    do {
        // Get the saved data
        let savedDataIn = try Data(contentsOf: fileURLIn)
        let savedDataOut = try Data(contentsOf: fileURLOut)
        // Convert the data back into a string
        if let savedString = String(data: savedDataIn, encoding: .utf8) {
            input = savedString.split(separator: "\n")

        }
        if let savedString = String(data: savedDataOut, encoding: .utf8) {
            result = String(savedString.split(separator: "\n")[0])

        }
    } catch {
        // Catch any errors
        print("Unable to read the file")
    }

    let days = startMCF(input, String(result))

    if Int(result)! == days {
        print("test \(i) - pass - \(days)")
        countPass += 1
    } else {
        print("test \(i) - wrong - \(days), correct - \(result)")
        countWrong += 1
    }



}

print("Pass Test: \(countPass) - Wrong Test: \(countWrong)")




