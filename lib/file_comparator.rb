require './lib/differ'
require './lib/decorator'

class FileComparator
  def self.process(file1, file2)
    arrays = [file1, file2].map { |file| File.read(file).split("\n") }

    Decorator.decorate_diff(
      *Differ.new(*arrays).process
    )
  end
end
