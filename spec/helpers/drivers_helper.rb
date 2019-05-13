# frozen_string_literal: true

module DriversHelper
  def operating_system
    if OS.linux?
      'linux'
    elsif OS.windows?
      'windows'
    elsif OS.mac?
      'mac'
    else
      raise "unknown os: #{OS.host}"
    end
  end

  def path_to_driver(driver)
    path = File.join(Dir.pwd, 'vendor', "#{driver}_#{operating_system}")
    path = "#{path}.exe" if operating_system == 'windows'
    path
  end
end
