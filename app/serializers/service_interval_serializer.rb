class ServiceIntervalSerializer
  def initialize(service_interval)
    @service_interval = service_interval
  end

  def as_json
    {
      id: @service_interval.id,
      name: @service_interval.name,
      thresholds: {
        hours: {
          threshold: @service_interval.threshold_hours,
          current: hours_since_last_service,
          remaining: hours_remaining
        },
        months: {
          threshold: @service_interval.threshold_months,
          current: months_since_last_service,
          remaining: months_remaining
        },
        kilometers: {
          threshold: @service_interval.threshold_km,
          current: km_since_last_service,
          remaining: km_remaining
        }
      },
      last_service: last_service_log&.completed_on,
      next_service_due: next_service_due
    }
  end

  private

  def last_service_log
    @last_service_log ||= @service_interval.service_logs.order(completed_on: :desc).first
  end

  def hours_since_last_service
    return 0 unless last_service_log

    activities = @service_interval.bike
      .user
      .strava_activities
      .where("start_date > ?", last_service_log.completed_on)
      .where(gear_id: @service_interval.bike.gear_id)

    activities.sum(:moving_time) / 3600.0 # Convert seconds to hours
  end

  def hours_remaining
    puts "hours_remaining: #{@service_interval.threshold_hours} - #{hours_since_last_service}"
    return @service_interval.threshold_hours if last_service_log.nil?
    [ @service_interval.threshold_hours - hours_since_last_service, 0 ].max
  end

  def months_since_last_service
    return 0 unless last_service_log
    ((Time.current.to_date - last_service_log.completed_on) / 30.0).round(1)
  end

  def months_remaining
    return nil if @service_interval.threshold_months.nil?
    return @service_interval.threshold_months if last_service_log.nil?
    [ @service_interval.threshold_months - months_since_last_service, 0 ].max
  end

  def km_since_last_service
    return 0 unless last_service_log

    activities = @service_interval.bike
      .user
      .strava_activities
      .where("start_date > ?", last_service_log.completed_on)
      .where(gear_id: @service_interval.bike.gear_id)

    activities.sum(:distance) / 1000.0 # Convert meters to kilometers
  end

  def km_remaining
        return nil if @service_interval.threshold_km.nil?

    return @service_interval.threshold_km if last_service_log.nil?
    [ @service_interval.threshold_km - km_since_last_service, 0 ].max
  end

  def next_service_due
    return nil unless last_service_log

    [
      last_service_log.completed_on + (@service_interval.threshold_months&.months || 0),
      hours_threshold_date,
      km_threshold_date
    ].compact.min
  end

  def hours_threshold_date
    return nil unless @service_interval.threshold_hours && hours_remaining < @service_interval.threshold_hours

    # Estimate date based on average daily hours
    return nil if hours_since_last_service == 0

    days_since_last_service = (Time.current.to_date - last_service_log.completed_on).to_i
    daily_hours = hours_since_last_service / days_since_last_service
    days_until_threshold = hours_remaining / daily_hours

    Time.current.to_date + days_until_threshold.days
  end

  def km_threshold_date
    return nil unless @service_interval.threshold_km && km_remaining < @service_interval.threshold_km

    # Estimate date based on average daily kilometers
    return nil if km_since_last_service == 0

    days_since_last_service = (Time.current.to_date - last_service_log.completed_on).to_i
    daily_km = km_since_last_service / days_since_last_service
    days_until_threshold = km_remaining / daily_km

    Time.current.to_date + days_until_threshold.days
  end
end
