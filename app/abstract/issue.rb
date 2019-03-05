class Issue
  def url
    fail NotImplementedError
  end

  def priority
    fail NotImplementedError
  end

  def subject
    fail NotImplementedError
  end

  def status
    fail NotImplementedError
  end

  def formatted_short
    "#{priority.ljust(10)} #{status.ljust(20)} #{subject}"
  end
end
