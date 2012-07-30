require 'test_helper'

class NuntiumControllerTest < ActionController::TestCase
  setup do
    http_auth(Nuntium::Config['incoming_username'], Nuntium::Config['incoming_password'])
  end

  test "should return message if ok via get" do
    pool = mock()
    Pool.expects(:first).returns(pool)

    wheel_combination = mock()
    WheelCombination.expects(:new).with(pool, '123').returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')

    get :recieve_at, :body => '123'

    assert_equal('Wheel Decoded Message', response.body)
  end

  test "should return message if ok via post" do
    pool = mock()
    Pool.expects(:first).returns(pool)

    wheel_combination = mock()
    WheelCombination.expects(:new).with(pool, '123').returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')

    @request.env['RAW_POST_DATA'] = '123'
    post :recieve_at

    assert_equal('Wheel Decoded Message', response.body)
  end
end
