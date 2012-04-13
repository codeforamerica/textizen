module PhoneUtils
  def normalize_phone(phone)
    puts 'normalizing phone %s' % phone
    if phone.match(/^\+/)
      phone = phone.slice(1,11)
    end
    puts 'normalized phone %s' % phone
    return phone
  end
end