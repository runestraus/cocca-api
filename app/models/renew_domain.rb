class RenewDomain
  include ActiveModel::Model

  attr_accessor :partner, :currency_code, :domain, :period, :renewed_at

  def self.all since:, up_to:
    RenewDomainQuery.run(since: since, up_to: up_to).collect { |row| self.new row }
  end

  def self.sync(since:, up_to:)
    all(since: since, up_to: up_to).each do |record|
      SyncRegisterDomainJob.perform_later record.as_json
    end
  end

  def as_json options = nil
    {
      partner: self.partner,
      currency_code: self.currency_code,
      order_details: [
        {
          type: 'domain_renew',
          domain: self.domain,
          period: self.period.to_i,
          renewed_at: self.renewed_at.to_time.utc.iso8601
        }
      ]
    }
  end
end
