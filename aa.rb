require 'csv'
require 'uri'

def extract_subdomain(url)
  uri = URI.parse(url)
  host = uri.host.downcase

  # Split the host by '.' and get the subdomain part
  # Assuming the domain always has a structure like 'subdomain.domain.tld'
  parts = host.split('.')
  return parts.size > 2 ? parts[0] : nil
rescue URI::InvalidURIError
  nil
end

def extract_path(url)
  uri = URI.parse(url)
  uri.path
rescue URI::InvalidURIError
  nil
end

csv_path = Rails.root.join('data/enrolment.csv')
# Read the CSV file
count = 0
BATCH_SIZE = 100
imported_count = 0

records = []

CSV.foreach(csv_path, headers: true) do |row|
  request_url = row['request_url']
  request_count = row['request_count']
  request_verb = row['request_verb']
  path = extract_path(request_url)
  school_name = extract_subdomain(request_url)

  count += 1
  records << { school_name: school_name, path: path, request_count: request_count, request_verb: request_verb}

  if count == BATCH_SIZE
    Analytic.import %i[school_name path request_count request_verb], records, validate: false
    count = 0
    records = []
    imported_count += BATCH_SIZE
    puts "Imported #{imported_count} records"
  end
end
