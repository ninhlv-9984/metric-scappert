class ContainerMetric < ApplicationRecord
  def self.convert_cpu(nanocores)
    nanocores.to_f / 1_000_000
  end

  # Converts kibibytes to megabytes
  def self.convert_memory(kibibytes)
    kibibytes.to_f / 1024
  end
end
