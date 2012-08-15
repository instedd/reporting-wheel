require 'test_helper'

class NuntiumControllerTest < ActionController::TestCase
  setup do
    http_auth(Nuntium::Config['incoming_username'], Nuntium::Config['incoming_password'])
  end

  test "should return message if ok" do
    user = User.make
    user.local_gateways.create! :address => '1234'

    pool = mock()
    Pool.expects(:first).returns(pool)

    wheel_combination = mock()
    WheelCombination.expects(:new).with(pool, '123', user).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')

    get :receive_at, :body => '123', :to => 'sms://1234'

    assert_equal('Wheel Decoded Message', response.body)
  end

  test "should return error message if no lgw" do
    get :receive_at, :body => '123', :to => 'sms://1234'

    assert_equal(I18n.t(:phone_not_lgw), response.body)
  end
end
