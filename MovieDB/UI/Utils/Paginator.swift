//
//  Paginator.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 02/07/26.
//

final class Paginator {
    
    private(set) var currentPage: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var isFetching: Bool = false
    
    var hasMorePages: Bool {
        currentPage <= totalPages
    }
    
    func reset() {
        currentPage = 1
        totalPages = 1
        isFetching = false
    }
    
    func beginFetch() -> Int? {
        guard !isFetching else { return nil }
        isFetching = true
        return currentPage
    }
    
    func completeFetch(fetchedPage: Int, totalPages: Int) {
        isFetching = false
        self.totalPages = totalPages
        currentPage = fetchedPage + 1
    }
    
    func failFetch() {
        isFetching = false
    }
}
