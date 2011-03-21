WHEEL_PRINT_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/printing_config.yml")['wheel']
WHEEL_ROW_PRINT_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/printing_config.yml")['wheel_row']
