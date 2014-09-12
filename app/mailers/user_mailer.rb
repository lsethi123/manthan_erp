class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def welcome(mails, subject, text)
    @subject = subject
    @text = text
    mail(to: mails , subject: @subject )
  end
  def special(mails)
    mail(to: mails , subject: "New Routes" )
  end
  def vendor(inv)
    @name = inv.name
    @type = inv.inventory_type
    @quantity = inv.quantity
    mail(to: 'navya@ostryalabs.com' , subject: "Deliveries" )
  end
end

