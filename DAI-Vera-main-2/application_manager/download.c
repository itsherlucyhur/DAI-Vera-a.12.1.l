#include <windows.h>
#include <wininet.h>
#include <stdio.h>

#pragma comment(lib, "wininet.lib")


int download_latest_release(const char *url, const char *output_path) {
    HINTERNET hInternet = InternetOpenA("DAI-Vera-Updater", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
    if (!hInternet) {
        printf("InternetOpenA failed.\n");
        return 1;
    }

    HINTERNET hFile = InternetOpenUrlA(hInternet, url, NULL, 0, INTERNET_FLAG_RELOAD, 0);
    if (!hFile) {
        printf("InternetOpenUrlA failed.\n");
        InternetCloseHandle(hInternet);
        return 1;
    }

    FILE *fp = fopen(output_path, "wb");
    if (!fp) {
        printf("Failed to open output file.\n");
        InternetCloseHandle(hFile);
        InternetCloseHandle(hInternet);
        return 1;
    }

    char buffer[4096];
    DWORD bytesRead;
    while (InternetReadFile(hFile, buffer, sizeof(buffer), &bytesRead) && bytesRead > 0) {
        fwrite(buffer, 1, bytesRead, fp);
    }

    fclose(fp);
    InternetCloseHandle(hFile);
    InternetCloseHandle(hInternet);
    return 0;
}