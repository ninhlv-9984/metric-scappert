class ClawMetricsJob
  include Sidekiq::Job

  def perform
    MetricsFetcher.new.fetch_and_store_pod_metrics
  end
end
