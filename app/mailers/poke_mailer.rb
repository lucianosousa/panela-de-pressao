class PokeMailer < ActionMailer::Base
  default from: "from@example.com"

  def poke(the_poke)
    @poke = the_poke
    mail(
      :to => the_poke.influencers.map{|i| "\"#{i.name}\" <#{i.email}>"}, 
      :subject => the_poke.campaign.name,
      :from => "\"#{the_poke.user.name}\" <#{the_poke.user.email}>"
    )
  end
end