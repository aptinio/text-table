# coding: utf-8
require 'integration_helper'

RSpec.describe Text::Table do
  let(:table) { Text::Table.new :rows => rows }
  let(:rows) do
    [
      ["Hello"],
      ["こんにちは"],
      ["مرحبا"],
      ["안녕하세요"],
    ]
  end

  subject { table.to_s }

  describe 'rows' do
    it { is_expected.to eq(deindent(%q{
      +------------+
      | Hello      |
      | こんにちは |
      | مرحبا      |
      | 안녕하세요 |
      +------------+
    })) }
  end
end
