require 'differ'

describe Differ do
  describe '#process' do
    subject { described_class.new(arr1, arr2).process }

    context 'when arrays are the same' do
      let(:arr1) { %w(a b c d e f g h) }
      let(:arr2) { %w(a b c d e f g h) }

      it do
        is_expected.to eq([
          ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
          ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        ])
      end
    end

    context 'when one element is added at the beginning' do
      let(:arr1) { %w(a b c d e f g h) }
      let(:arr2) { %w(m a b c d e f g h) }

      it do
        is_expected.to eq([
          [nil, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
          ['m', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        ])
      end
    end

    context 'with two matched blocks and both arrays have the same length' do
      let(:arr1) { %w(a b c m d e f g h) }
      let(:arr2) { %w(l a b j f g h c d) }

      it do
        is_expected.to eq([
          [nil, 'a', 'b', 'c', 'm', 'd', 'e', 'f', 'g', 'h', nil, nil],
          ['l', 'a', 'b', nil, 'j', nil, nil, 'f', 'g', 'h', 'c', 'd']
        ])
      end
    end

    context 'with three matched blocks and the second array is smaller' do
      let(:arr1) { %w(a b c d e f g h d c) }
      let(:arr2) { %w(l a b f g h c d) }

      it do
        is_expected.to eq([
          [nil, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', nil, 'd', 'c'],
          ['l', 'a', 'b', nil, nil, nil, 'f', 'g', 'h', 'c', 'd', nil]
        ])
      end
    end

    context 'with three matched blocks and the second array is bigger' do
      let(:arr1) { %w(l a b f g h c d) }
      let(:arr2) { %w(a b c d e f g h d c) }

      it do
        is_expected.to eq([
          ['l', 'a', 'b', nil, nil, nil, 'f', 'g', 'h', nil, 'c', 'd'],
          [nil, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'd', 'c', nil]
        ])
      end
    end
  end
end
