require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:email) { UserMailer.with(user: user).welcome_email }

  describe 'welcome email' do

    it 'renders the subject' do
      expect(email.subject).to eq("Welcome to Odin Facebook")
    end
    
    it 'renders the receiver email' do
      expect(email.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(email.from).to eq(['notifications@odin-facebook.com'])
    end

    it 'assigns full_name' do
      expect(email.body.encoded).to match(user.full_name)
    end

    it 'assigns login url' do
      expect(email.body.encoded).to match(new_user_session_url)
    end

    it 'sends an email' do
      expect { email.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end
end
