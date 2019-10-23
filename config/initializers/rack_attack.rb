Rack::Attack.throttle('orders/new', limit: 10, period: 1.minute) do |request|
  
  if request.path.include?('/orders/new'.freeze)
    request.ip
  end
end

Rack::Attack.blocklist('orders-new-ban-from-site') do |request|

  Rack::Attack::Fail2Ban.filter("ban-throttle-orders/new-#{request.ip}", maxretry: 0, findtime: 1.minute, bantime: 1.day) do
    
    count = Rails.cache.read("rack::attack:#{Time.now.to_i/1.minute}:'orders/new'}:#{request.ip}")

    count && count.to_i > 10

  end

end
