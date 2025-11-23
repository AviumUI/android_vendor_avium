/* 
 * Copyright (C) 2025 The AviumUI Project
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <string>
#include <map>

namespace avium {
namespace utils {

// log message to both android log and stdout
void LogWithStdOut(const std::string& status, const std::string& message);

// read config file and parse key-value pairs into a map
std::map<std::string, std::string> ParseConfigFile(const std::string& config_path);

// check if a given key is enabled in the config map
bool IsEnabled(const std::map<std::string, std::string>& config, 
               const std::string& key,
               bool default_value);

// get the value of a given key in the config map
std::string GetConfigValue(const std::map<std::string, std::string>& config,
                           const std::string& key,
                           const std::string& default_value);

}  // namespace utils
}  // namespace avium