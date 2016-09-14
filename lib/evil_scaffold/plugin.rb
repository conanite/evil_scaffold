module EvilScaffold
  GENERATORS = []

  def self.add_generator &block
    mod = Module.new &block
    GENERATORS << mod
    mod
  end
end
