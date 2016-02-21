require 'file_comparator'

describe FileComparator do
  describe '.process' do
    let(:file1) { './spec/fixtures/1.txt' }
    let(:file2) { './spec/fixtures/2.txt' }

    subject { described_class.process(file1, file2) }

    it do
      is_expected.to eq([
        '1. * Some|Another',
        '2. - Simple',
        '3.   Text',
        '4.   File',
        '5. + With',
        '6. + Additional',
        '7. + Lines'
      ].join("\n"))
    end

    context 'in reverse order' do
      subject { described_class.process(file2, file1) }
      
      it 'decorates diff' do
        is_expected.to eq([
          '1. * Another|Some',
          '2. + Simple',
          '3.   Text',
          '4.   File',
          '5. - With',
          '6. - Additional',
          '7. - Lines'
        ].join("\n"))
      end
    end
  end
end
