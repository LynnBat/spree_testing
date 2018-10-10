describe 'my_account_page' do
  before { visit '/login' }

  context 'displaying information' do
    it 'displays email'
    it 'displays store credits'
    it 'displays orders'
  end

  context 'editing information' do
    it 'can change the email'
    it 'can change password'
  end
end