class User < ActiveRecord::Base
  acts_as_our_cities_user

  attr_accessible :admin, :email, :phone, :first_name, :last_name
  has_many :authorizations
  has_many :campaigns
  has_many :pokes
  has_many :moderations, class_name: "Campaign", foreign_key: "moderator_id"
  has_and_belongs_to_many :collaborations, :class_name => "Campaign"

  validates_uniqueness_of :email

  scope :by_campaign_id,  ->(campaign_id) { Poke.where(campaign_id: campaign_id).map{|p| p.user} }
  scope :subscribers,     where(:subscriber => true)
  scope :pokers,          where("(SELECT count(*) FROM pokes WHERE pokes.user_id = users.id) > 0")

  def self.create_from_hash!(hash)
    create(
      :email =>       hash['info']['email'],
      :first_name =>  hash['info']['first_name'],
      :last_name =>   hash['info']['last_name']
    )
  end

  def update_ip ip
    if Rails.env.production? || Rails.env.staging?
      begin
        url = "#{ENV["ACCOUNTS_HOST"]}/users/#{self.id}.json"
        body = { token: ENV["ACCOUNTS_API_TOKEN"], user: { ip: ip } }
        HTTParty.patch(url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
      rescue Exception => e
        logger.error e.message
      end
    end
  end

  def facebook_authorization
    authorizations.where(:provider => "facebook").first
  end

  def carrierwave_pic options = {:type => "large"}
    self.file.send(options[:type]).url
  end

  def twitter_authorization
    authorizations.where(:provider => "twitter").first
  end

  def has_poked campaign
    self.pokes.where(:campaign_id => campaign.id).any?
  end

  def reported? campaign
    campaign.reports.where(user_id: id).any?
  end
end
