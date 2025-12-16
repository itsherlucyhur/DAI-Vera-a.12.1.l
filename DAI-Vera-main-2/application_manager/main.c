#include <windows.h>
#include <wininet.h>
#include <stdio.h>
#include <string.h>
#include <shlobj.h>
#include <stdlib.h>
#include "constants.h"

#define STATE_FILE "state.dat"

int download_latest_release(const char *url, const char *output_path);
int run_installer_default(const char *installer_path);
void get_current_directory(char *buffer, size_t size);
void find_executable_in_directory(const char *base_dir, const char *exe_name, char *result_path, size_t result_size);
void find_executable_in_program_files(const char *app_name, const char *exe_name, char *result_path, size_t result_size);
void generate_matlab_constants(const char *invesalius_path, const char *slicer_path);
void update_slicer_ini(void);

int file_exists(const char *filename) {
    DWORD attrib = GetFileAttributesA(filename);
    return (attrib != INVALID_FILE_ATTRIBUTES && !(attrib & FILE_ATTRIBUTE_DIRECTORY));
}

// Helper function to get current directory
void get_current_directory(char *buffer, size_t size) {
    GetCurrentDirectoryA((DWORD)size, buffer);
}

// Helper function to run installer with default settings
int run_installer_default(const char *installer_path) {
    STARTUPINFOA si = { sizeof(si) };
    PROCESS_INFORMATION pi;
    char command_line[1024];
    
    // Try running installer with default settings (no silent mode)
    snprintf(command_line, sizeof(command_line), "\"%s\"", installer_path);
    
    printf("Running installer: %s\n", command_line);
    printf("Please complete the installation process...\n");
    
    if (!CreateProcessA(NULL, command_line, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        printf("Failed to start installer. Error: %lu\n", GetLastError());
        return 1;
    }
    
    // Wait for installation to complete
    printf("Waiting for installation to complete...\n");
    WaitForSingleObject(pi.hProcess, INFINITE);
    
    DWORD exit_code;
    GetExitCodeProcess(pi.hProcess, &exit_code);
    
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    
    printf("Installation completed with exit code: %lu\n", exit_code);
    
    return 0;
}

// Helper function to recursively find executable in directory
void find_executable_in_directory(const char *base_dir, const char *exe_name, char *result_path, size_t result_size) {
    WIN32_FIND_DATAA find_data;
    HANDLE hFind;
    char search_path[MAX_PATH];
    char full_path[MAX_PATH];
    
    // First check if exe is directly in the base directory
    snprintf(full_path, sizeof(full_path), "%s\\%s", base_dir, exe_name);
    if (file_exists(full_path)) {
        strncpy(result_path, full_path, result_size - 1);
        result_path[result_size - 1] = '\0';
        return;
    }
    
    // Search recursively in subdirectories
    snprintf(search_path, sizeof(search_path), "%s\\*", base_dir);
    hFind = FindFirstFileA(search_path, &find_data);
    
    if (hFind != INVALID_HANDLE_VALUE) {
        do {
            if ((find_data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) &&
                strcmp(find_data.cFileName, ".") != 0 &&
                strcmp(find_data.cFileName, "..") != 0) {
                
                // Check in subdirectory
                snprintf(full_path, sizeof(full_path), "%s\\%s\\%s", base_dir, find_data.cFileName, exe_name);
                if (file_exists(full_path)) {
                    strncpy(result_path, full_path, result_size - 1);
                    result_path[result_size - 1] = '\0';
                    FindClose(hFind);
                    return;
                }
                
                // Recursively search deeper
                char sub_dir[MAX_PATH];
                snprintf(sub_dir, sizeof(sub_dir), "%s\\%s", base_dir, find_data.cFileName);
                find_executable_in_directory(sub_dir, exe_name, result_path, result_size);
                if (result_path[0] != '\0') {
                    FindClose(hFind);
                    return;
                }
            }
        } while (FindNextFileA(hFind, &find_data));
        FindClose(hFind);
    }
}

// Helper function to search for executable in Program Files directories
void find_executable_in_program_files(const char *app_name, const char *exe_name, char *result_path, size_t result_size) {
    char program_files[MAX_PATH];
    char program_files_x86[MAX_PATH];
    char search_path[MAX_PATH];
    
    // Get Program Files paths
    if (SHGetFolderPathA(NULL, CSIDL_PROGRAM_FILES, NULL, SHGFP_TYPE_CURRENT, program_files) == S_OK) {
        snprintf(search_path, sizeof(search_path), "%s\\%s", program_files, app_name);
        find_executable_in_directory(search_path, exe_name, result_path, result_size);
        if (result_path[0] != '\0') return;
        
        // Also search directly in Program Files
        find_executable_in_directory(program_files, exe_name, result_path, result_size);
        if (result_path[0] != '\0') return;
    }
    
    // Try Program Files (x86)
    if (SHGetFolderPathA(NULL, CSIDL_PROGRAM_FILESX86, NULL, SHGFP_TYPE_CURRENT, program_files_x86) == S_OK) {
        snprintf(search_path, sizeof(search_path), "%s\\%s", program_files_x86, app_name);
        find_executable_in_directory(search_path, exe_name, result_path, result_size);
        if (result_path[0] != '\0') return;
        
        // Also search directly in Program Files (x86)
        find_executable_in_directory(program_files_x86, exe_name, result_path, result_size);
        if (result_path[0] != '\0') return;
    }
    
    // Try common installation locations
    const char *common_paths[] = {
        "C:\\Program Files\\InVesalius 3",
        "C:\\Program Files (x86)\\InVesalius 3",
        "C:\\Program Files\\3D Slicer",
        "C:\\Program Files (x86)\\3D Slicer",
        "C:\\Slicer",
        "C:\\InVesalius"
    };
    
    for (int i = 0; i < sizeof(common_paths) / sizeof(common_paths[0]); i++) {
        find_executable_in_directory(common_paths[i], exe_name, result_path, result_size);
        if (result_path[0] != '\0') return;
    }
}

// Function to download latest release
int download_latest_release(const char *url, const char *output_path) {
    HINTERNET hInternet, hUrl;
    DWORD bytesRead;
    BYTE buffer[4096];
    FILE *file;
    
    printf("Downloading from: %s\n", url);
    printf("Output path: %s\n", output_path);
    
    // Initialize WinINet
    hInternet = InternetOpenA("Application Manager", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
    if (!hInternet) {
        printf("Failed to initialize internet connection. Error: %lu\n", GetLastError());
        return 1;
    }
    
    // Open URL
    hUrl = InternetOpenUrlA(hInternet, url, NULL, 0, INTERNET_FLAG_RELOAD, 0);
    if (!hUrl) {
        printf("Failed to open URL. Error: %lu\n", GetLastError());
        InternetCloseHandle(hInternet);
        return 1;
    }
    
    // Open output file
    file = fopen(output_path, "wb");
    if (!file) {
        printf("Failed to create output file: %s\n", output_path);
        InternetCloseHandle(hUrl);
        InternetCloseHandle(hInternet);
        return 1;
    }
    
    // Download and write to file
    printf("Downloading...\n");
    while (InternetReadFile(hUrl, buffer, sizeof(buffer), &bytesRead) && bytesRead > 0) {
        fwrite(buffer, 1, bytesRead, file);
        printf(".");
        fflush(stdout);
    }
    printf("\nDownload completed.\n");
    
    // Cleanup
    fclose(file);
    InternetCloseHandle(hUrl);
    InternetCloseHandle(hInternet);
    
    return 0;
}

// Function to update Slicer.ini file
void update_slicer_ini(void) {
    char slicer_ini_path[MAX_PATH];
    char username[256];
    DWORD username_size = sizeof(username);
    
    // Get current username
    if (!GetUserNameA(username, &username_size)) {
        printf("Warning: Could not get username to update Slicer.ini\n");
        return;
    }
    
    // Construct path to Slicer.ini
    snprintf(slicer_ini_path, sizeof(slicer_ini_path), 
             "C:\\Users\\%s\\AppData\\Roaming\\slicer.org\\Slicer.ini", username);
    
    printf("Updating Slicer configuration file: %s\n", slicer_ini_path);
    
    // Check if file exists
    if (!file_exists(slicer_ini_path)) {
        printf("Warning: Slicer.ini file not found at %s\n", slicer_ini_path);
        return;
    }
    
    // Read existing file content
    FILE *file = fopen(slicer_ini_path, "r");
    if (!file) {
        printf("Warning: Could not open Slicer.ini for reading\n");
        return;
    }
    
    // Read file into memory
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    char *content = malloc(file_size + 1);
    if (!content) {
        printf("Warning: Could not allocate memory for Slicer.ini content\n");
        fclose(file);
        return;
    }
    
    fread(content, 1, file_size, file);
    content[file_size] = '\0';
    fclose(file);
    
    // Find and replace windowState line
    char *windowState_line = strstr(content, "windowState=");
    if (windowState_line) {
        // Find the end of the line
        char *line_end = strchr(windowState_line, '\n');
        if (!line_end) {
            line_end = content + file_size;
        }
        
        // The new windowState value
        const char *new_windowState = "windowState=\"@ByteArray(\\0\\0\\0\\xff\\0\\0\\0\\0\\xfd\\0\\0\\0\\x3\\0\\0\\0\\0\\0\\0\\x2\\xc9\\0\\0\\x4\\x1e\\xfc\\x2\\0\\0\\0\\x1\\xfb\\0\\0\\0\\x1e\\0P\\0\\x61\\0n\\0\\x65\\0l\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\x1\\0\\0\\0\\x15\\0\\0\\x4\\x1e\\0\\0\\x1\\v\\0\\xff\\xff\\xff\\0\\0\\0\\x1\\0\\0\\x1/\\0\\0\\x3\\xca\\xfc\\x2\\0\\0\\0\\x1\\xfb\\0\\0\\0$\\0\\x45\\0r\\0r\\0o\\0r\\0L\\0o\\0g\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\xe8\\0\\xff\\xff\\xff\\0\\0\\0\\x3\\0\\0\\x4\\xb0\\0\\0\\0h\\xfc\\x1\\0\\0\\0\\x1\\xfb\\0\\0\\0.\\0P\\0y\\0t\\0h\\0o\\0n\\0\\x43\\0o\\0n\\0s\\0o\\0l\\0\\x65\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\0\\0\\0\\x2\\xd0\\0\\0\\x4\\xb0\\0\\0\\0U\\0\\xff\\xff\\xff\\0\\0\\x4\\xb0\\0\\0\\x4\\x1e\\0\\0\\0\\x4\\0\\0\\0\\x4\\0\\0\\0\\x1\\0\\0\\0\\x2\\xfc\\0\\0\\0\\x3\\0\\0\\0\\x2\\0\\0\\0\\b\\0\\0\\0\\x16\\0M\\0\\x61\\0i\\0n\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0*\\0M\\0o\\0\\x64\\0u\\0l\\0\\x65\\0S\\0\\x65\\0l\\0\\x65\\0\\x63\\0t\\0o\\0r\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1a\\0M\\0o\\0\\x64\\0u\\0l\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x16\\0V\\0i\\0\\x65\\0w\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0 \\0M\\0o\\0u\\0s\\0\\x65\\0M\\0o\\0\\x64\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1c\\0\\x43\\0\\x61\\0p\\0t\\0u\\0r\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1c\\0V\\0i\\0\\x65\\0w\\0\\x65\\0r\\0s\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1a\\0\\x44\\0i\\0\\x61\\0l\\0o\\0g\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x2\\0\\0\\0\\x1\\0\\0\\0\\x1c\\0M\\0\\x61\\0r\\0k\\0u\\0p\\0s\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x2\\0\\0\\0\\x1\\0\\0\\0,\\0S\\0\\x65\\0q\\0u\\0\\x65\\0n\\0\\x63\\0\\x65\\0\\x42\\0r\\0o\\0w\\0s\\0\\x65\\0r\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0)\"";
        
        // Calculate new content size
        size_t prefix_len = windowState_line - content;
        size_t suffix_len = content + file_size - line_end;
        size_t new_content_size = prefix_len + strlen(new_windowState) + suffix_len;
        
        char *new_content = malloc(new_content_size + 1);
        if (!new_content) {
            printf("Warning: Could not allocate memory for new Slicer.ini content\n");
            free(content);
            return;
        }
        
        // Copy prefix
        memcpy(new_content, content, prefix_len);
        
        // Copy new windowState line
        strcpy(new_content + prefix_len, new_windowState);
        
        // Copy suffix
        memcpy(new_content + prefix_len + strlen(new_windowState), line_end, suffix_len);
        new_content[new_content_size] = '\0';
        
        // Write new content to file
        FILE *output_file = fopen(slicer_ini_path, "w");
        if (output_file) {
            fwrite(new_content, 1, new_content_size, output_file);
            fclose(output_file);
            printf("Successfully updated Slicer.ini windowState configuration\n");
        } else {
            printf("Warning: Could not write to Slicer.ini file\n");
        }
        
        free(new_content);
    } else {
        // If windowState doesn't exist, append it
        FILE *output_file = fopen(slicer_ini_path, "a");
        if (output_file) {
            fprintf(output_file, "\nwindowState=\"@ByteArray(\\0\\0\\0\\xff\\0\\0\\0\\0\\xfd\\0\\0\\0\\x3\\0\\0\\0\\0\\0\\0\\x2\\xc9\\0\\0\\x4\\x1e\\xfc\\x2\\0\\0\\0\\x1\\xfb\\0\\0\\0\\x1e\\0P\\0\\x61\\0n\\0\\x65\\0l\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\x1\\0\\0\\0\\x15\\0\\0\\x4\\x1e\\0\\0\\x1\\v\\0\\xff\\xff\\xff\\0\\0\\0\\x1\\0\\0\\x1/\\0\\0\\x3\\xca\\xfc\\x2\\0\\0\\0\\x1\\xfb\\0\\0\\0$\\0\\x45\\0r\\0r\\0o\\0r\\0L\\0o\\0g\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\xe8\\0\\xff\\xff\\xff\\0\\0\\0\\x3\\0\\0\\x4\\xb0\\0\\0\\0h\\xfc\\x1\\0\\0\\0\\x1\\xfb\\0\\0\\0.\\0P\\0y\\0t\\0h\\0o\\0n\\0\\x43\\0o\\0n\\0s\\0o\\0l\\0\\x65\\0\\x44\\0o\\0\\x63\\0k\\0W\\0i\\0\\x64\\0g\\0\\x65\\0t\\0\\0\\0\\x2\\xd0\\0\\0\\x4\\xb0\\0\\0\\0U\\0\\xff\\xff\\xff\\0\\0\\x4\\xb0\\0\\0\\x4\\x1e\\0\\0\\0\\x4\\0\\0\\0\\x4\\0\\0\\0\\x1\\0\\0\\0\\x2\\xfc\\0\\0\\0\\x3\\0\\0\\0\\x2\\0\\0\\0\\b\\0\\0\\0\\x16\\0M\\0\\x61\\0i\\0n\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0*\\0M\\0o\\0\\x64\\0u\\0l\\0\\x65\\0S\\0\\x65\\0l\\0\\x65\\0\\x63\\0t\\0o\\0r\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1a\\0M\\0o\\0\\x64\\0u\\0l\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x16\\0V\\0i\\0\\x65\\0w\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0 \\0M\\0o\\0u\\0s\\0\\x65\\0M\\0o\\0\\x64\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1c\\0\\x43\\0\\x61\\0p\\0t\\0u\\0r\\0\\x65\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1c\\0V\\0i\\0\\x65\\0w\\0\\x65\\0r\\0s\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x1a\\0\\x44\\0i\\0\\x61\\0l\\0o\\0g\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x2\\0\\0\\0\\x1\\0\\0\\0\\x1c\\0M\\0\\x61\\0r\\0k\\0u\\0p\\0s\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\x2\\0\\0\\0\\x1\\0\\0\\0,\\0S\\0\\x65\\0q\\0u\\0\\x65\\0n\\0\\x63\\0\\x65\\0\\x42\\0r\\0o\\0w\\0s\\0\\x65\\0r\\0T\\0o\\0o\\0l\\0\\x42\\0\\x61\\0r\\0\\0\\0\\0\\0\\xff\\xff\\xff\\xff\\0\\0\\0\\0\\0\\0\\0\\0)\"\n");
            fclose(output_file);
            printf("Successfully added Slicer.ini windowState configuration\n");
        } else {
            printf("Warning: Could not append to Slicer.ini file\n");
        }
    }
    
    free(content);
}

// Function to generate MATLAB constants file
void generate_matlab_constants(const char *invesalius_path, const char *slicer_path) {
    FILE *file = fopen("app_paths.m", "w");
    if (!file) {
        printf("Warning: Could not create MATLAB constants file\n");
        return;
    }
    
    fprintf(file, "%% Auto-generated MATLAB constants file\n");
    fprintf(file, "%% Contains paths to installed applications\n");
    fprintf(file, "%% Generated by Application Manager\n\n");
    
    fprintf(file, "function paths = app_paths()\n");
    fprintf(file, "    %% Application paths structure\n");
    fprintf(file, "    paths = struct();\n\n");
    
    if (invesalius_path[0] != '\0') {
        // Escape backslashes for MATLAB
        char escaped_path[MAX_PATH * 2];
        int j = 0;
        for (int i = 0; invesalius_path[i] != '\0' && j < sizeof(escaped_path) - 2; i++) {
            if (invesalius_path[i] == '\\') {
                escaped_path[j++] = '\\';
                escaped_path[j++] = '\\';
            } else {
                escaped_path[j++] = invesalius_path[i];
            }
        }
        escaped_path[j] = '\0';
        
        fprintf(file, "    %% InVesalius executable path\n");
        fprintf(file, "    paths.invesalius = '%s';\n\n", escaped_path);
    } else {
        fprintf(file, "    %% InVesalius not found\n");
        fprintf(file, "    paths.invesalius = '';\n\n");
    }
    
    if (slicer_path[0] != '\0') {
        // Escape backslashes for MATLAB
        char escaped_path[MAX_PATH * 2];
        int j = 0;
        for (int i = 0; slicer_path[i] != '\0' && j < sizeof(escaped_path) - 2; i++) {
            if (slicer_path[i] == '\\') {
                escaped_path[j++] = '\\';
                escaped_path[j++] = '\\';
            } else {
                escaped_path[j++] = slicer_path[i];
            }
        }
        escaped_path[j] = '\0';
        
        fprintf(file, "    %% 3D Slicer executable path\n");
        fprintf(file, "    paths.slicer = '%s';\n\n", escaped_path);
    } else {
        fprintf(file, "    %% 3D Slicer not found\n");
        fprintf(file, "    paths.slicer = '';\n\n");
    }
    
    fprintf(file, "end\n");
    
    fclose(file);
    printf("MATLAB constants file generated: app_paths.m\n");
}

int main() {
    char invesalius_path[MAX_PATH] = {0};
    char slicer_path[MAX_PATH] = {0};
    
    if (!file_exists(STATE_FILE)) {
        printf("First run. Downloading latest release...\n");
        
        // Download InVesalius
        if (download_latest_release(GITHUB_RELEASE_URL_INV, "latest_invesalius.exe") != 0) {
            printf("Download failed: invesalius check %s\n", GITHUB_RELEASE_URL_INV);
            return 1;
        }
        
        // Download Slicer
        if (download_latest_release(GITHUB_RELEASE_URL_SLICER, "latest_slicer.exe") != 0) {
            printf("Download failed: slicer check %s\n", GITHUB_RELEASE_URL_SLICER);
            return 1;
        }
        
        // Run InVesalius installer with default settings
        printf("Installing InVesalius with default settings...\n");
        if (run_installer_default("latest_invesalius.exe") != 0) {
            printf("InVesalius installation failed\n");
            // Don't return - continue with Slicer installation
        }
        
        // Run Slicer installer with default settings
        printf("Installing Slicer with default settings...\n");
        if (run_installer_default("latest_slicer.exe") != 0) {
            printf("Slicer installation failed\n");
            // Don't return - continue to search for executables
        } else {
            // Update Slicer.ini after successful installation
            printf("Updating Slicer configuration...\n");
            update_slicer_ini();
        }
        
        // Create state file
        FILE *f = fopen(STATE_FILE, "w");
        if (f) {
            fputs("executed", f);
            fclose(f);
        }
        
        printf("Installation process completed. Searching for executables...\n");
    }
    
    // Search for InVesalius executable in common locations
    printf("Searching for InVesalius executable...\n");
    find_executable_in_program_files("InVesalius", "invesalius.exe", invesalius_path, sizeof(invesalius_path));
    if (invesalius_path[0] == '\0') {
        find_executable_in_program_files("InVesalius 3", "invesalius.exe", invesalius_path, sizeof(invesalius_path));
    }
    
    // Search for Slicer executable in common locations
    printf("Searching for 3D Slicer executable...\n");
    find_executable_in_program_files("3D Slicer", "Slicer.exe", slicer_path, sizeof(slicer_path));
    if (slicer_path[0] == '\0') {
        find_executable_in_program_files("Slicer", "Slicer.exe", slicer_path, sizeof(slicer_path));
    }
    
    // Print the paths
    printf("\n=== Application Paths ===\n");
    printf("InVesalius executable path: %s\n", invesalius_path[0] ? invesalius_path : "Not found");
    printf("Slicer executable path: %s\n", slicer_path[0] ? slicer_path : "Not found");
    
    // Generate MATLAB constants file
    printf("\nGenerating MATLAB constants file...\n");
    generate_matlab_constants(invesalius_path, slicer_path);
    
    printf("\nApplication manager completed successfully!\n");
    printf("Use the generated 'app_paths.m' file in your MATLAB code.\n");

    return 0;
}
