require 'decorator'

describe Decorator do
  describe '.decorate_diff' do
    let(:arr1) { [nil, 'a', 'b', 'c', 'm', 'd', 'e', 'f', 'g', 'h', nil, nil] }
    let(:arr2) { ['l', 'a', 'b', nil, 'j', nil, nil, 'f', 'g', 'h', 'c', 'd'] }

    subject { described_class.decorate_diff(arr1, arr2) }

    it 'decorates diff' do
      is_expected.to eq([
        '1. + l',
        '2.   a',
        '3.   b',
        '4. - c',
        '5. * m|j',
        '6. - d',
        '7. - e',
        '8.   f',
        '9.   g',
        '10.   h',
        '11. + c',
        '12. + d'
      ].join("\n"))
    end

    context 'in reverse order' do
      subject { described_class.decorate_diff(arr2, arr1) }
      
      it 'decorates diff' do
        is_expected.to eq([
          '1. - l',
          '2.   a',
          '3.   b',
          '4. + c',
          '5. * j|m',
          '6. + d',
          '7. + e',
          '8.   f',
          '9.   g',
          '10.   h',
          '11. - c',
          '12. - d'
        ].join("\n"))
      end
    end
  end
end
