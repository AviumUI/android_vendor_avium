#pragma once

#include <string>
#include <map>

namespace avium {
namespace utils {


// read config file and parse key-value pairs into a map
std::map<std::string, bool> ParseConfigFile(const std::string& config_path);

// check if a given key is enabled in the config map
bool IsEnabled(const std::map<std::string, bool>& config, 
               const std::string& key,
               bool default_value);

}  // namespace utils
}  // namespace avium