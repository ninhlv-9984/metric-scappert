class HomeController < ApplicationController
  def index
  end

  def pods_data
    @metrics = ContainerMetric.all.order(:created_at)
    grouped_metrics = @metrics.where(namespace: "default").group_by(&:name)

    formatted_data = grouped_metrics.map do |name, metrics|
      {
        name: name,
        data: metrics.map { |metric| { time: metric.created_at.strftime("%Y-%m-%d %H:%M:%S"), cpu: metric.cpu_millicores, memory: metric.memory_mb } }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: formatted_data }
    end
  end

  def chart_data
    top20_analytics = Analytic.group(:school_name).count.sort_by { |k, v| v }.reverse.first(20)

    grouped_analytics = Analytic.group(:school_name).count
    labels = []
    data = []
    backgroundColor = []
    borderColor = []

    top20_analytics.each do |school_name, count|
      labels << school_name
      data << count
      backgroundColor << "rgba(#{rand(0..255)}, #{rand(0..255)}, #{rand(0..255)}, 0.2)"
      borderColor << "rgba(#{rand(0..255)}, #{rand(0..255)}, #{rand(0..255)}, 1)"
    end



    res = {
      labels: labels,
      datasets: [{
        label: '# of Requests',
        data: data,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: 1
      }]
    }

    render json: res
  end

  def chart_request_data
    number_of_requests = Analytic.group(:controller, :action_name).count.keys.count
    top20_percent = Analytic.group(:controller, :action_name).count.sort_by { |k, v| v }.reverse.first(number_of_requests * 0.1)

    labels = []
    data = []
    backgroundColor = []
    borderColor = []

    top20_percent.each do |request, count|
      labels << "#{request[0]}##{request[1]}"
      data << count
      backgroundColor << "rgba(#{rand(0..255)}, #{rand(0..255)}, #{rand(0..255)}, 0.2)"
      borderColor << "rgba(#{rand(0..255)}, #{rand(0..255)}, #{rand(0..255)}, 1)"
    end

    res = {
      labels: labels,
      datasets: [{
        label: '# of Requests',
        data: data,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: 1
      }]
    }

    render json: res
  end
end
