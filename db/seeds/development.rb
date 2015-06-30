user = User.create(
  email: "user@example.com", 
  password: "asdqwe123", 
  password_confirmation: "asdqwe123"
)

require Rails.root.join(*%w(db seeds payment))