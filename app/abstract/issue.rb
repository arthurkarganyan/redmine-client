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

  def description
    fail NotImplementedError
  end

  def formatted_short
    "#{priority.ljust(8)} #{status.ljust(12)} #{subject.ljust(45)} #{url}"
  end
end
