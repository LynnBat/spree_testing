class Credentials
  attr_reader :email, :password

  def initialize
    @email    = Faker::Internet.unique.email
    @password = ENV['PASSWORD_SPREE']
  end
end