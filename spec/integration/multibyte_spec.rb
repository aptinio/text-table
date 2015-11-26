require 'integration_helper'

RSpec.describe Text::Table, 'with multibyte cells' do
  let(:table) { Text::Table.new rows: rows }
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
    xit { is_expected.to eq(deindent(%q{
      +------------+
      | Hello      |
      | こんにちは |
      | مرحبا      |
      | 안녕하세요 |
      +------------+
    })) }
  end
end
