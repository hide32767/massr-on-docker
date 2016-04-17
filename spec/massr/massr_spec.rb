require 'spec_helper'

packages_ubuntu = YAML.load_file('packages_ubuntu.yaml')


describe "Dockerfile" do

  packages_ubuntu.each do |pkg|
    describe package(pkg), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end
  end

  describe command(%q{node --version}) do
    its(:stdout) { should match /v/ }
  end

  describe command(%q{locale -a}) do
    its(:stdout) { should match /ja_JP.utf8/ }
  end

  describe file('/etc/gemrc') do
    it { should be_file }
  end

  describe file('/etc/profile.d/rbenv.sh') do
    it { should be_file }
  end

  describe command(%q{bash -lc 'ruby --version'}) do
    its(:stdout) { should match /ruby 2.2.4/ }
  end

  describe command(%q{bash -lc 'bundle --version'}) do
    its(:stdout) { should match /Bundler version/ }
  end

  describe group('webapp') do
    it { should be_exist }
  end

  describe user('webapp') do
    it { should be_exist }
    it { should belong_to_group 'webapp' }
    it { should have_home_directory '/home/webapp' }
    it { should have_login_shell '/bin/dash' }
  end

  describe file('/home/webapp/.pit') do
    it { should be_directory }
    it { should be_mode '700' }
    it { should be_owned_by 'webapp' }
    it { should be_grouped_into 'webapp' }
  end

  describe file('/home/webapp/.pit/default.yaml') do
    it { should be_file }
    it { should be_mode '600' }
    it { should be_owned_by 'webapp' }
    it { should be_grouped_into 'webapp' }
    its(:content) { should_not match /YOUR_TWITTER_API_KEY/ }
    its(:content) { should_not match /YOUR_TWITTER_API_SECRET/ }
    its(:content) { should_not match /YOUR_GMAIL_ADDRESS/ }
    its(:content) { should_not match /YOUR_GMAIL_APP_PASSWORD/ }
  end

  describe file('/home/webapp/.pit/pit.yaml') do
    it { should be_file }
    it { should be_mode '600' }
    it { should be_owned_by 'webapp' }
    it { should be_grouped_into 'webapp' }
  end

  describe file('/srv/webapp/massr.rb') do
    it { should be_file }
  end

  describe file('/srv/webapp/.env') do
    it { should be_file }
    it { should be_mode '600' }
    it { should be_owned_by 'webapp' }
    it { should be_grouped_into 'webapp' }
    its(:content) { should match /RACK_ENV='development'/ }
  end

  describe file('/srv/webapp/Gemfile.lock') do
    it { should be_file }
  end

  describe file('/srv/massr_boot.sh') do
    it { should be_file }
    it { should be_mode '700' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

end
