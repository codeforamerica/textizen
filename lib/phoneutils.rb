module PhoneUtils
  def normalize_phone(phone)
    if phone.match(/^\+/)
      phone = phone.slice(1,10)
    end
    return phone
  end
end