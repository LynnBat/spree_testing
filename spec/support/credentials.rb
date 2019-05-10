class Credentials
  attr_reader :email, :password

  def initialize
    @email    = Faker::Internet.unique.safe_email
    @password = ENV['PASSWORD_SPREE']
  end
end