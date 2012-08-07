# coding: utf-8
class CampaignsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :create]
  before_filter :only => [:create] { params[:campaign][:user_id] = current_user.id }
  before_filter :only => [:show] { @poke = Poke.new }
  before_filter :only => [:show] { @answer = Answer.new }
  before_filter :only => [:index] { @highlight_campaign = Campaign.accepted.first }

  def create
    create! do |success, failure|
      success.html do 
        bitly = Bitly.new(ENV['BITLY_ID'], ENV['BITLY_SECRET'])
        resource.update_attribute :short_url, bitly.shorten(Rails.application.routes.url_helpers.campaign_url(resource.id)).short_url
        return redirect_to campaigns_path, :notice => "Aí! Recebemos a sua campanha. Em breve entraremos em contato para colocá-la no ar..."
      end
      failure.html { render :new }
    end
  end

  def accept
    Campaign.find(params[:campaign_id]).update_attribute :accepted_at, Time.now
    params[:id] = params[:campaign_id]
    show(:notice => "Está valendo, campanha no ar!")
  end

  def index
    if params[:user_id]
      render :user_index
    end
  end

  protected
  def collection
    if params[:user_id]
      @campaigns ||= end_of_association_chain.where(:user_id => params[:user_id])
    elsif current_user && current_user.admin?
      @campaigns ||= Campaign.all
    else
      @campaigns ||= end_of_association_chain.accepted
    end
  end
end
