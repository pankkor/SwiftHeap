import Foundation

public struct Heap<T> {
    public typealias Comparator = (T, T) -> Bool
    @usableFromInline let compare: Comparator

    @usableFromInline var array = [T]()

    @inlinable public init(compare: @escaping Comparator) {
        self.compare = compare
    }

    @inlinable public init(array: [T], compare: @escaping Comparator) {
        self.array = array
        self.compare = compare

        for i in (0..<array.count / 2).reversed() {
            heapifyDown(i)
        }
    }

    @inlinable public mutating func insert(_ e: T) {
        array.append(e)
        heapifyUp(array.count - 1)
    }

    @inlinable public mutating func removeTop() {
        guard array.count > 0 else { return }

        if array.count == 1 {
            array.removeLast()
            return
        }

        array.swapAt(0, array.count - 1)
        array.removeLast()
        heapifyDown()
    }

    @inlinable public var top: T? { return array.first }
    @inlinable public var count: Int { return array.count }

    @inline(__always) private func leftIndex(_ idx: Int) -> Int { return 2 * idx + 1 }
    @inline(__always) private func rightIndex(_ idx: Int) -> Int { return 2 * idx + 2 }
    @inline(__always) private func parentIndex(_ idx: Int) -> Int { return (idx - 1) / 2 }

    @usableFromInline mutating func heapifyUp(_ idx: Int) {
        var idx = idx
        var parentIdx = parentIndex(idx)

        while parentIdx >= 0 {
            guard compare(array[idx], array[parentIdx]) else { return }

            array.swapAt(idx, parentIdx)

            idx = parentIdx
            parentIdx = parentIndex(idx)
        }
    }

    @usableFromInline mutating func heapifyDown(_ idx: Int = 0) {
        assert(idx >= 0 && idx < array.count)
        var idx = idx

        while true {
            let leftIdx = leftIndex(idx)
            let rightIdx = rightIndex(idx)

            var newIdx = idx
            if leftIdx < array.count && compare(array[leftIdx], array[newIdx]) {
                newIdx = leftIdx
            }
            if rightIdx < array.count && compare(array[rightIdx], array[newIdx]) {
                newIdx = rightIdx
            }

            if newIdx == idx { return }

            array.swapAt(idx, newIdx)
            idx = newIdx
        }
    }
}

extension Heap: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}
