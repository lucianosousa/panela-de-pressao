# coding: utf-8
class CampaignsController < InheritedResources::Base
  def create
    create! do |success, failure|
      success.html { redirect_to campaigns_path, :notice => "Aí! Recebemos a sua campanha. Em breve entraremos em contato para colocá-la no ar..." }
    end
  end

  protected
  def collection
    @campaigns ||= end_of_association_chain.accepted
  end
end
