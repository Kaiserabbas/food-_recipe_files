require 'rails_helper'

RSpec.describe 'Foods', type: :system do
  include Devise::Test::IntegrationHelpers

  before(:each) do
    email = "unique_email_#{SecureRandom.hex(5)}@example.com"
    @user = User.create(
      name: 'Qaisar Abbas',
      email: email,
      password: 'password',
      confirmed_at: Time.now,
      confirmation_sent_at: Time.now
    )
    @user.save!
    sign_in @user

    @food = Food.create(
      name: 'Tufo',
      measurement_unit: 'KG',
      price: 20.00,
      quantity: 4,
      user: @user
    )
  end

  describe '#index' do
    before(:each) do
      visit foods_path
    end

    it 'should display food name' do
      expect(page).to have_content(@food.name)
    end

    it 'should display food measurement unit' do
      expect(page).to have_content(@food.measurement_unit)
      expect(page).to have_content(@food.price)
      expect(page).to have_content(@food.quantity)
    end
      
    it 'on clicking on a food, should redirect to that food show page' do
      click_on @food.name
      expect(page).to have_current_path(food_path(@food))
    end
  end
end
