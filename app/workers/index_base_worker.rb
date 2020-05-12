class IndexBaseWorker
  def initialize(worker)
    @worker = worker
  end

  def perform(arg_hash)
    @worker.execute(arg_hash)
  end
end
