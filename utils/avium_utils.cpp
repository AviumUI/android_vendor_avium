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

#include "avium_utils.h"

#include <sstream>
#include <string>
#include <map>

#include <android-base/file.h>
#include <android-base/logging.h>


using android::base::ReadFileToString;

namespace avium {
namespace utils {

inline std::string Trim(const std::string &s) {
    auto start = s.find_first_not_of(" \t");
    auto end = s.find_last_not_of(" \t");
    return (start == std::string::npos) ? "" : s.substr(start, end - start + 1);
}

std::map<std::string, bool> ParseConfigFile(const std::string& config_path) {
    std::map<std::string, bool> config_map;
    std::string file_contents;
    if (!android::base::ReadFileToString(config_path, &file_contents)) {
        LOG(INFO) << "Config file not found (" << config_path << "), returning empty config.";
        return config_map;
    }

    std::istringstream stream(file_contents);
    std::string line;
    while (std::getline(stream, line)) {
        // Remove comments
        auto comment_pos = line.find('#');
        if (comment_pos != std::string::npos) {
            line = line.substr(0, comment_pos);
        }
        line = Trim(line);
        if (line.empty()) continue;

        auto eq_pos = line.find('=');
        if (eq_pos == std::string::npos) continue;

        std::string key = Trim(line.substr(0, eq_pos));
        std::string value = Trim(line.substr(eq_pos + 1));

        //Covert value to bool
        bool enabled = (value == "true" || value == "1");
        config_map[key] = enabled;
    }

    return config_map;
}

bool IsEnabled(const std::map<std::string, bool>& config, 
               const std::string& key,
               bool default_value = true) {
    auto it = config.find(key);
    bool result = (it != config.end()) ? it->second : default_value;
    LOG(INFO) << "Config key \"" << key << "\" -> " 
              << (result ? "enabled" : "disabled");
    return result;
}

}  // namespace utils
}  // namespace avium