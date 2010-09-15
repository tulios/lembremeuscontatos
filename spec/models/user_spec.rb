require 'spec_helper'

describe User do

  before(:each) { @user = Factory(:user) }
  subject { @user }

  context 'quando referente ao login' do
    it { should validate_presence_of :login }
    it { should validate_format_of(:login).with('twit_login') }
    it { should ensure_length_of(:login).is_at_least(1).is_at_most(15) }
    it { should validate_uniqueness_of(:login).case_insensitive }
  end

  context 'quando referente ao id do twitter' do
    it { should validate_presence_of :twitter_id }
    it { should validate_uniqueness_of(:twitter_id).with_message(/ID has already been taken/) }
  end

  context 'quando referente ao plano basico do usuario' do
    it { should validate_presence_of :plano_id }
  end

end

