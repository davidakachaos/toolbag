def redirect_to(options = {}, response_status = {})
  ::Rails.logger.info("Redirected by #{caller(1).first rescue "unknown"}")
  super(options, response_status)
end