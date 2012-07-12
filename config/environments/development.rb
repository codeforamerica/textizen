TxtyourcityRails::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  
#   $outbound_flocky = Flocky.new(1234,5678,90)
#   def $outbound_flocky.message(from,message,numbers)
#     puts "LOGG: sending a message '#{message}' from #{from} to #{numbers.inspect}"
#   end

#   def $outbound_flocky.create_phone_number_synchronous(area_code)
#     num = area_code+Array.new(7) {("0".."9").to_a[rand(10)]}*""
#     puts "LOGG: provision number #{num}"
#     response= Object.new
#     def response.code
#       200
#     end
#     def response.parsed_response
#       {"href"=>"https://api.tropo.com/v1/applications/1234/addresses/number/+#{@num}"}
#     end
#     response.instance_variable_set("@num",num)
#     {:url=>nil, :response=>response}
#   end
#   def $outbound_flocky.destroy_phone_number_synchronous(phone_number)
#     puts "LOGG: destroy phone provision #{phone_number}"
#   end
#   def $outbound_flocky.create_phone_number_asynchronous(area_code)
#     create_phone_number_synchronous(area_code)
#   end
#   def $outbound_flocky.destroy_phone_number_asynchronous(area_code)
#     destroy_phone_number_synchronous(area_code)
#   end
  

  #logging for foreman
  STDOUT.sync = true
end
