module NewsHelper
  
  # Display a date as a  simple textual description relative to the the current date.
  def relative_date(date)
    date = Date.parse(date, true) unless /Date.*/ =~ date.class.to_s
    days = (date - Date.today).to_i
    
    return 'Today'     if days >= 0 and days < 1
    return 'Yesterday' if days >= -1 and days < 0
    
    return date.strftime('%A') if days.abs < 7 and days < 0
    
    return date.strftime('%b. %e') if days.abs < 182
    return date.strftime('%b. %e, %Y')
  end
  
end
