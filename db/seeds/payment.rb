["Credit", "Cash"].each do |p|
  payment = Payment.new
  payment.name = p
  payment.save
end