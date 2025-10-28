class MarkCartAsAbandonedJob
  include Sidekiq::Job
  sidekiq_options queue: :default, retry: 3

  INACTIVITY_LIMIT = 3.hours
  PURGE_AFTER      = 7.days

  def perform
    now = Time.current

    ts_column = if Cart.column_names.include?("last_interacted_at")
                  "last_interacted_at"
                else
                  "last_interaction_at"
                end

    Cart.active.where("#{ts_column} <= ?", now - INACTIVITY_LIMIT).find_each do |cart|
      cart.mark_abandoned!
    end

    Cart.where(status: :abandoned).where("abandoned_at <= ?", now - PURGE_AFTER).find_each(&:destroy!)
  end
end
