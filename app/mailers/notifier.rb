class Notifier < ActionMailer::Base
  default :from => "admin@riaple.net"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.user_created.subject
  #

  def user_created(user)
    @greeting = "Hi"

    @user = user

    mail :to => user.email, :subject => "Wellcome to Riaple"
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.task_assigned.subject
  #
  def task_assigned
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
end
