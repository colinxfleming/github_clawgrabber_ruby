require 'test_helper'

# Test that the context shell initializes and makes binding accessible
class FetcherTest < TestClass
  before { stub_github }

  describe 'constants' do
    it 'should set the GraphQL endpoint' do
      assert_equal 'https://api.github.com/graphql',
                   GithubClawgrabber::Fetcher::GITHUB_GRAPHQL_ENDPOINT
    end
  end

  describe 'fetching' do
    it 'makes a single file call' do
      response = GithubClawgrabber::Fetcher.fetch(
        'valid_token',
        'colinxfleming/github_clawgrabber_ruby',
        'samples/each_loop.txt.erb',
        'master'
      )

      assert_equal 'samples/each_loop.txt.erb', response[0][:file]
      assert_equal "<% [1, 2, 3, 4, 5].each do |num| %>\n  <%= num %> * 2 = <%= num * 2 %>\n<\% end %>\n",
                   response[0][:content]
    end
  end

  describe 'private methods' do
    it 'makes clean api calls' do
      response = GithubClawgrabber::Fetcher.send(
        :make_api_call,
        'valid_token',
        'colinxfleming/github_clawgrabber_ruby',
        'samples/each_loop.txt.erb',
        'master'
      )

      assert_equal 200, response.code
      assert_equal SUCCESSFUL_CALL_HEADERS, response.headers
      assert_equal SUCCESSFUL_CALL_BODY, response.body
    end

    # TODO test header setting
    # TODO test shaping post json
  end
end
