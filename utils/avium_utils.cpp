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

#include <sys/klog.h>
#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <iostream>

#include <android-base/file.h>
#include <android-base/logging.h>

#define SYSLOG_ACTION_SIZE_BUFFER 10
#define SYSLOG_ACTION_READ_ALL    3

using android::base::ReadFileToString;

namespace avium {
namespace utils {

void StdOutLog(const std::string& status, const std::string& message) {
    std::cout << status << ": " << message << std::endl;
}

void LogWithStdOut(const std::string& status, const std::string& message) {
    if (message.empty()) {
        return;
    }
    if (status.empty()) {
        LOG(INFO) << "Log level is empty, default to info";
        StdOutLog("I", "Log level is empty, default to info");
        LOG(INFO) << message;
        StdOutLog("I", message);
    }else if (status == "E" || status == "ERROR") {
        LOG(ERROR) << message;
    } else if (status == "W" || status == "WARNING") {
        LOG(WARNING) << message;
    } else if (status == "I" || status == "INFO") {
        LOG(INFO) << message;
    } else if (status == "D" || status == "DEBUG") {
        LOG(DEBUG) << message;
    } else {
        LOG(INFO) << "Unknown log level: " << status << ", defaulting to INFO";
        LOG(INFO) << message;
    }
    StdOutLog(status, message);
}

inline std::string Trim(const std::string &s) {
    auto start = s.find_first_not_of(" \t");
    auto end = s.find_last_not_of(" \t");
    return (start == std::string::npos) ? "" : s.substr(start, end - start + 1);
}

std::map<std::string, std::string> ParseConfigFile(const std::string& config_path) {
    std::map<std::string, std::string> config_map;
    std::string file_contents;

    if (!android::base::ReadFileToString(config_path, &file_contents)) {
        LOG(INFO) << "Config file not found (" << config_path << "), creating empty file.";

        if (!android::base::WriteStringToFile("", config_path)) {
            LOG(ERROR) << "Failed to create config file: " << config_path;
        }

        return config_map;
    }

    std::istringstream stream(file_contents);
    std::string line;

    while (std::getline(stream, line)) {
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

        config_map[key] = value;
    }

    return config_map;
}

bool IsEnabled(const std::map<std::string, std::string>& config, 
               const std::string& key,
               bool default_value) {

    auto it = config.find(key);
    if (it == config.end()) {
        LOG(INFO) << "Config key \"" << key << "\" not found -> "
                  << (default_value ? "enabled(default)" : "disabled(default)");
        return default_value;
    }

    std::string value = it->second;

    std::transform(value.begin(), value.end(), value.begin(), ::tolower);

    bool result = (value == "1" ||
                   value == "true" ||
                   value == "yes" ||
                   value == "on" ||
                   value == "enabled");

    LOG(INFO) << "Config key \"" << key << "\" = \"" << it->second
              << "\" -> " << (result ? "enabled" : "disabled");
    return result;
}

std::string GetConfigValue(const std::map<std::string, std::string>& config,
              const std::string& key,
              const std::string& default_value) {
    auto it = config.find(key);
    if (it == config.end()) {
        LOG(INFO) << "Config key \"" << key << "\" not found -> using default value: \""
                  << default_value << "\"";
        return default_value;
        
    }
    LOG(INFO) << "Config key \"" << key << "\" = \"" << it->second << "\"";
    return it->second;
}

std::string GetKmsg() {
    int size = klogctl(SYSLOG_ACTION_SIZE_BUFFER, nullptr, 0);
    if (size < 0) {
        perror("klogctl size");
        return "error: klogctl size failed";
    }
    // get klog
    std::vector<char> buffer(size + 1);
    int n = klogctl(SYSLOG_ACTION_READ_ALL, buffer.data(), size);
    if (n < 0) {
        perror("klogctl read");
        return "error: klogctl read failed";
    }
    buffer[n] = '\0';
    
    std::string klog(buffer.data());
    return klog;
}

}  // namespace utils
}  // namespace avium