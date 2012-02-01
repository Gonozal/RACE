# Load configuration file for RACE Modules (visible in the main navigation)
NAV_MODULES = YAML.load_file(File.join(Rails.root, "config", "modules.yml"))