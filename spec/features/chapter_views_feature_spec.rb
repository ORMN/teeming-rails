require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'


context "when testing with a normal user" do
  before do
    Rails.application.load_seed # loading seeds
    user.update(setup_state: nil)
    sign_in user
  end

  describe "shows dashboard" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      visit home_users_path
    end

    it "displays the main page" do
      expect(page).to have_selector "a[href='/chapters']"
    end
  end

  describe "show members button available when user has rights to view members" do
    let(:chapter) { Chapter.find_by_name("Duluth") }

    before do
      visit chapter_path(chapter)
    end

    context "when testing for chapter items for all users" do
      let(:user) { FactoryGirl.create(:user) }

      it "displays the Duluth chapter page" do
        expect(page).to have_text "Duluth"
        expect(page).to have_text "Activity"
        expect(page).to have_selector "a[href='#{chapter_path(chapter, tab: :governance)}']"
      end
    end

    context "when the user is a normal user" do
      let(:user) { FactoryGirl.create(:user) }

      it "displays the view members button" do
        expect(page).to_not have_selector "a[href='#{chapter_members_path(chapter)}']"
        expect(page).to_not have_selector "a[href='#{chapter_members_path(chapter, show_potential_members: true)}']"
        expect(page).to_not have_selector "a[href='#{new_election_path(chapter_id: chapter.id)}']"
      end
    end

    context "when the user has member viewing privileges for this chapter" do
      let(:user) {
        FactoryGirl.create(:user,
          role: Role.new(privileges:
                  [Privilege.new(subject: 'member',
                                 action: 'view',
                                 scope: {chapter_id: chapter.id}.to_json)]))
      }

      it "displays the view members button" do
        expect(page).to have_selector "a[href='#{chapter_members_path(chapter)}']"
        expect(page).to have_selector "a[href='#{chapter_members_path(chapter, show_potential_members: true)}']"
      end
    end

    context "when the user has manage internal election privileges for this chapter" do
      let(:user) {
        FactoryGirl.create(:user,
                           role: Role.new(privileges:
                                              [Privilege.new(subject: 'election',
                                                             action: 'manage_internal',
                                                             scope: {chapter_id: chapter.id}.to_json)]))
      }

      it "displays the view members button" do
        expect(page).to have_selector "a[href='#{new_election_path(chapter_id: chapter.id)}']"
      end
    end
  end
end

