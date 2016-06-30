require 'spec_helper'

describe PulpoBot::Commands::Questions do
  def app
    PulpoBot::Bot.instance
  end
  it 'returns an string' do
    expect(message: "@#{SlackRubyBot.config.user} hello", channel: 'channel').to respond_with_slack_message('4')
  end
end