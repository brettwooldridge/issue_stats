require 'rails_helper'

RSpec.describe RepositoriesController, :type => :controller do

  describe "GET show" do
    it "returns http success", :vcr do
      get :show, owner: "hstove", repository: "rbtc_arbitrage"
      expect(response).to be_success
    end
  end

  describe 'GET badge', :vcr do
    context 'concise badges' do
      it 'should have concise language' do
        get :badge, owner: 'hstove', repository: 'rbtc_arbitrage', variant: :issue, concise: true
        expect(response).to redirect_to(%r{https://img.shields.io/badge/issue%20closure})
      end
    end
    context 'not enough data' do
      it 'should redirect correctly' do
        get :badge, owner: 'hstove', repository: 'issue_stats', variant: :pr
        expect(response).to redirect_to(%r{https://img.shields.io/badge/pull%20requests%20closed})
      end
    end

    context 'for repos not found' do
      it 'should redirect correctly' do
        get :badge, owner: 'hstove', repository: 'fakefakefake', variant: :issue
        expect(response).to redirect_to(%r{https://img.shields.io/badge/})
      end
    end

    it 'should render not found badge when invalid variant' do
      get :badge, owner: 'hstove', repository: 'rbtc_arbitrage', variant: :fake, style: :flat
      expect(response).to redirect_to('https://img.shields.io/badge/Issue_Stats-Not_Found-lightgrey.svg?style=flat')
    end

    it 'should pass along the style param' do
      get :badge, owner: 'hstove', repository: 'rbtc_arbitrage', variant: :issue, style: 'flat-square'
      expect(response).to redirect_to(%r{\?style=flat-square})
    end
  end

end
