describe Transit do

  describe '.get_routes' do
    let(:from) { "123 Fake Street, Victoria BC" }
    let(:to) { "456 Somewhere Street, Kelowna BC" }

    it 'constructs the query params' do
      pending("don't worry about this right now")
      expect(URI).to receive(:encode_www_form).with({ origin: from, destination: to, departure_time: Time.now, mode: 'transit' })
    end
  end
end
