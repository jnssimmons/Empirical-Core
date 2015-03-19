require 'rails_helper'

feature 'Activity Listing Progress Report', js: true do
  before(:each) { vcr_ignores_localhost }

  let(:report_page) { Teachers::ActivityProgressReportPage.new }

  include_context 'Activity Progress Report'

  context 'for a logged-in teacher' do
    before do
      sign_in_user mr_kotter
      report_page.visit
    end

    it 'displays the right headers' do
      expect(report_page.column_headers).to eq(
        [
          'App',
          'Activity',
          'Date',
          'Time Spent',
          'Standard',
          'Score',
          'Student'
        ]
      )
    end

    it 'displays activity session data in the table' do
      expect(report_page.table_rows.first).to eq(
        [
          activity.classification.name,
          activity.name,
          horshack_session.completed_at.to_formatted_s(:quill_default),
          '2 minutes',
          'topic', # Derived from topic #
          '75%',
          horshack.name
        ]
      )
    end

    it 'can filter by classroom' do
      report_page.filter_by_classroom(sweatdogs.name)
      expect(report_page.table_rows.size).to eq(1)
    end
  end
end