// Models.swift
import Foundation // 要引用這個才能使用 UUID()

struct GalleryItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let symbolImageName: String?
}

struct StitchDetail: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
}

struct VideoItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL
}
