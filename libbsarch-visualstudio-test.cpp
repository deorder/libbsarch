#include <iostream>

#include "libbsarch.h"

#pragma comment(lib, "libbsarch")

int main() {
	bsa_archive_t archive = bsa_create();

	bsa_result_message_t result = bsa_load_from_file(archive, L"test_read.bsa");
  if(result.code < 0)
    printf("%ls\n", result.text);
	bsa_close(archive);
  
	bsa_entry_list_t entries = bsa_entry_list_create();
	bsa_entry_list_add(entries, L"textures\\grass\\test.dds");

	bsa_create_archive(archive, L"test_write.bsa", baSSE, entries);
	bsa_add_file_from_disk(archive, L"files", L"files\\textures\\grass\\test.dds");
	bsa_save(archive);
	bsa_close(archive);

	bsa_entry_list_free(entries);

	bsa_free(archive);
}
