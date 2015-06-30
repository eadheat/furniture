module SignInAs
  def sign_in_as(user = FactoryGirl.create(:user))
    token = sign_in user
    yield token
  end
end