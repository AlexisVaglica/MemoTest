//
//  Globals.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

final class Globals {
    static let shared = Globals()
    private init() {}
    
    public let TMDB_Base_URL : String = "https://api.themoviedb.org/3/"
    public let TMDB_Image_URL : String = "https://image.tmdb.org/t/p/w500/"
    public let loader_name : String = "loader_anim"
    public let background_image_name : String = "background_image"
    public let title_image_name : String = "title_image"
    public let card_background_name : String = "back_card_image_violet"
    public let back_button_name : String = "back_image"
    public let match_background_name : String = "cards_match_background"
}
