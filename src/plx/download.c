#include <plx/download.h>
#include <curl/curl.h>

typedef struct {
    FILE *fp;
    size_t dl_total;
} dl_status;

size_t write_data(void *ptr, size_t size, size_t nmemb, void *stream) {
    dl_status *status = (dl_status *)stream;
    size_t written = fwrite(ptr, size, nmemb, status->fp);

    status->dl_total += written;

    printf("\r%ld KB   ", status->dl_total / 1024);
    fflush(stdout);

    return written;
}

bool plx_download_file(char *url, char *filename) {
    bool success = true;

    CURL *curl_handle = curl_easy_init();

    curl_easy_setopt(curl_handle, CURLOPT_URL, url);
    curl_easy_setopt(curl_handle, CURLOPT_VERBOSE, 0L);
    curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(curl_handle, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, write_data);
    curl_easy_setopt(curl_handle, CURLOPT_FAILONERROR, 1L);
    
    FILE *pagefile = fopen(filename, "wb");

    if(pagefile) {
        dl_status status;
        status.dl_total = 0;
        status.fp = pagefile;

        curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, &status);
        
        for (int i=0; i<5; i++) {
            if (curl_easy_perform(curl_handle)) {
                success = false;
                printf("failure %d\n", (i+1));
            } else {
                success = true;
            }

            if (success) {
                break;
            }

            sleep(1);
        }
        
        fclose(pagefile);

        if (!success) {
            remove(pagefile);
        }

        printf("\n");
    }

    curl_easy_cleanup(curl_handle);

    return success;
}