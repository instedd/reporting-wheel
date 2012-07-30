class Nuntium
  Config = YAML.load_file("#{Rails.root}/config/nuntium.yml")[Rails.env]
  def self.new_from_config
    Nuntium.new Config['url'], Config['account'], Config['application'], Config['password']
  end
end
