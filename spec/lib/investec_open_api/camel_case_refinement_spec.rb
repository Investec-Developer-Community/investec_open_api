require 'spec_helper'
require 'investec_open_api/camel_case_refinement'

RSpec.describe InvestecOpenApi::CamelCaseRefinement do
  using InvestecOpenApi::CamelCaseRefinement

  it 'converts snake_case keys to camelCase' do
    hash = { 'first_key' => 1, 'second_key' => 2 }
    expected = { 'firstKey' => 1, 'secondKey' => 2 }
    expect(hash.camelize).to eq(expected)
  end

  it 'leaves keys without underscores unchanged' do
    hash = { 'key' => 1 }
    expect(hash.camelize).to eq(hash)
  end

  it 'handles empty hashes' do
    expect({}.camelize).to eq({})
  end
end
