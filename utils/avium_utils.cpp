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
#include <selinux/selinux.h>
#include <fs_mgr.h>
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

inline std::string Trim(const std::string &s) {
    auto start = s.find_first_not_of(" \t");
    auto end = s.find_last_not_of(" \t");
    return (start == std::string::npos) ? "" : s.substr(start, end - start + 1);
}

bool IsCommentLine(const std::string& line) {
    std::string t = Trim(line);
    return (!t.empty() && t[0] == '#');
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

bool ReplaceInputLine(const std::string& input, 
                      const std::string& new_value,
                      const std::string& path) {
    std::string content;
    if (!android::base::ReadFileToString(path, &content)) {
        LOG(ERROR) << "Read file failed: " << path;
        return false;
    }

    std::vector<std::string> lines;
    std::string line;
    std::istringstream ss(content);

    bool changed = false;
    while (std::getline(ss, line)) {
        if (!line.empty() && line.back() == '\r') {
            line.pop_back();
        }

        if (line.rfind(input, 0) == 0) {
            line = input + "=" + new_value;
            changed = true;
        }
        lines.push_back(line);
    }
    if (!changed){
        return true;
    }

    std::string new_content;
    for (size_t i = 0; i < lines.size(); ++i) {
        new_content += lines[i];
        if (i + 1 < lines.size()) {
            new_content += "\n";
        }
    }

    // Write back to file
    if (!android::base::WriteStringToFile(new_content, path)) {
        LOG(ERROR) << "Write file failed: " << path;
        return false;
    }

    return true;
}

std::string SELinuxStatusFromBoot() {
    std::string value;
    if (android::fs_mgr::GetKernelCmdline("androidboot.selinux", &value) && value == "permissive") {
        return "permissive";
    }
    if (android::fs_mgr::GetBootconfig("androidboot.selinux", &value) && value == "permissive") {
        return "permissive";
    }
    return "enforcing";
}

std::string GetSELinuxStatusFromApi(){
    int status = security_getenforce();
    if (status == 1) {
        return "enforcing";
    } else if (status == 0) {
        return "permissive";
    } else {
        return "disabled_or_error";
    }
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