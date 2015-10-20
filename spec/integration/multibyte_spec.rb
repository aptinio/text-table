require 'integration_helper'

describe Text::Table do
  let(:table) { Text::Table.new :rows => rows }
  let(:rows) do
    [
      %w(Hello),
      %w(こんにちは),
      %w(مرحبا),
      %w(안녕하세요),
    ]
  end

  subject { table.to_s }

  describe 'rows' do
    it { should == deindent(%q{
      +------------+
      | Hello      |
      | こんにちは |
      | مرحبا      |
      | 안녕하세요 |
      +------------+
    }) }
  end
end
