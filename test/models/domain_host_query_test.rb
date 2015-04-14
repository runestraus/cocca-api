require 'test_helper'

describe DomainHostQuery do
  before do
    create_domain_host audit_time: audit_time

    create_domain_host audit_time: audit_time, partner: EXCLUDED_PARTNER
    create :excluded_partner
  end

  let(:since) { '2015-03-04 14:00'.in_time_zone }
  let(:up_to) { '2015-03-04 14:30'.in_time_zone }

  describe :all do
    subject { DomainHostQuery.run since: since, up_to: up_to, audit_operation: 'I'  }

    context :when_record_created_within_period do
      let(:audit_time) { up_to }

      specify { subject.count.must_equal 1 }
      specify { subject.first['partner'].must_equal 'alpha' }
      specify { subject.first['domain'].must_equal 'domains.ph' }
      specify { subject.first['host'].must_equal 'ns5.domains.ph' }
    end

    context :when_record_created_before_period do
      let(:audit_time) { since - 1.day }

      specify { subject.must_be_empty }
    end

    context :when_record_created_after_period do
      let(:audit_time) { since + 1.day }

      specify { subject.must_be_empty }
    end

    context :when_record_created_at_the_end_of_last_period do
      let(:audit_time) { since }

      specify { subject.must_be_empty }
    end
  end
end
