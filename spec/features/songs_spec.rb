require 'rails_helper'
describe "songs", type:  :feature do

  before do
    Artist.destroy_all
    Song.destroy_all
    @artist = Artist.create!(name: "Daft Punk")
    @song = @artist.songs.create!(title: "The Grid")
  end

  describe "/songs/:id" do

    it "links to the artist" do
      visit song_path(@song)
      expect(page).to have_link("Daft Punk", href: artist_path(@artist))
    end

    it "links to edit when no artist" do
      song = Song.create(title: "Policy of Truth")
      visit song_path(song)
      expect(page).to have_link("Add Artist", href: edit_song_path(song))
    end

  end

  describe "/songs" do

    it "links to the song" do
      visit songs_path
      expect(page).to have_link("The Grid", href: song_path(@song))
    end

    it "has a link to edit the song if no artist" do
      song = Song.create(title: "Mambo No. 5")
      visit songs_path
      expect(page).to have_link("Add Artist", href: edit_song_path(song))
    end

  end

  describe "song uploads" do
    it "can upload a songs file" do
      visit songs_path
      attach_file("file", Rails.root.join("spec", "fixtures", "songs.csv"))
      find(:xpath, "//input[contains(@name, 'commit')]").click()
      song = Song.find_by(title: "Caught Up in You")
      expect(page).to have_link("Caught Up in You", href: song_path(song))
    end
  end
end
