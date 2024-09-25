class WaitlistMailer < ApplicationMailer
  def new_signup(email)
    @email = email
    mail(to: "dylan.runkel@gmail.com", subject: "New Waitlist Signup")
  end
end
