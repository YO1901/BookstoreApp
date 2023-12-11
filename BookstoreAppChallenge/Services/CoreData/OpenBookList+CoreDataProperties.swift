//
//  OpenBookList+CoreDataProperties.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 11.12.2023.
//
//

import Foundation
import CoreData


extension OpenBookList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpenBookList> {
        return NSFetchRequest<OpenBookList>(entityName: "OpenBookList")
    }

    @NSManaged public var title: String?
    @NSManaged public var book: NSOrderedSet?

}

// MARK: Generated accessors for book
extension OpenBookList {

    @objc(insertObject:inBookAtIndex:)
    @NSManaged public func insertIntoBook(_ value: OpenBook, at idx: Int)

    @objc(removeObjectFromBookAtIndex:)
    @NSManaged public func removeFromBook(at idx: Int)

    @objc(insertBook:atIndexes:)
    @NSManaged public func insertIntoBook(_ values: [OpenBook], at indexes: NSIndexSet)

    @objc(removeBookAtIndexes:)
    @NSManaged public func removeFromBook(at indexes: NSIndexSet)

    @objc(replaceObjectInBookAtIndex:withObject:)
    @NSManaged public func replaceBook(at idx: Int, with value: OpenBook)

    @objc(replaceBookAtIndexes:withBook:)
    @NSManaged public func replaceBook(at indexes: NSIndexSet, with values: [OpenBook])

    @objc(addBookObject:)
    @NSManaged public func addToBook(_ value: OpenBook)

    @objc(removeBookObject:)
    @NSManaged public func removeFromBook(_ value: OpenBook)

    @objc(addBook:)
    @NSManaged public func addToBook(_ values: NSOrderedSet)

    @objc(removeBook:)
    @NSManaged public func removeFromBook(_ values: NSOrderedSet)

}

extension OpenBookList : Identifiable {

}
