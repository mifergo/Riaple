require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "user_created" do
    mail = Notifier.user_created
    assert_equal "User created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "task_assigned" do
    mail = Notifier.task_assigned
    assert_equal "Task assigned", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
