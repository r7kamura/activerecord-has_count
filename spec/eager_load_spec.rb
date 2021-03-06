require "spec_helper"

describe "#eager_load" do
  describe "has_count association" do
    let(:tweets_count) { 3 }
    let(:tweets) do
      tweets_count.times.map do
        FactoryGirl.create(:tweet)
      end
    end

    before do
      tweets.each_with_index do |tweet, index|
        index.times do
          FactoryGirl.create(:reply, tweet: tweet)
        end
      end
    end

    it "raises ActiveRecord::EagerLoadHasCountError" do
      # Currently this is not supported because I can't come up with how to implement.
      # I'm waiting for your contribution.
      expect {
        Tweet.all.eager_load(:replies_count).map(&:replies_count)
      }.to raise_error(ActiveRecord::EagerLoadHasCountError)
    end
  end
end
