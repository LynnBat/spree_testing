class User
  attr_reader :email, :password, :name, :first_name, :last_name, :street_address, :secondary_address, :city, :state, :zip, :phone, :mobile

  def initialize
    @email        = Faker::Internet.unique.safe_email
    @password     = Faker::Internet.password

    @name         = Faker::Name.name
    @first_name   = Faker::Name.first_name
    @last_name    = Faker::Name.last_name

    @house_number = Faker::Address.building_number
    @street       = Faker::Address.street_name
    @city         = Faker::Address.city
    @state        = Faker::Address.state
    @zip          = Faker::Address.zip
    @phone        = Faker::PhoneNumber.phone_number
  end
end
