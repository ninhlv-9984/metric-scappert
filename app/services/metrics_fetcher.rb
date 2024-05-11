require 'json'
require 'open3'

class MetricsFetcher

  def fetch_and_store_pod_metrics
    raw_metrics, status = Open3.capture2('kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods"')
    if status.success?
      process_metrics(JSON.parse(raw_metrics))
    else
      Rails.logger.error "Failed to fetch metrics: #{raw_metrics}"
    end
  end

  private

  def process_metrics(response)
    response["items"].each do |item|
      item["containers"].each do |container|
        ContainerMetric.create(
          name: item["metadata"]["name"],
          cpu_millicores: ContainerMetric.convert_cpu(container["usage"]["cpu"].delete('n').to_i),
          memory_mb: ContainerMetric.convert_memory(container["usage"]["memory"].delete('Ki').to_i),
          namespace: item["metadata"]["namespace"],
        )
      end
    end
  end
end
