#include <iostream>
#include <windows.h>

#include "libbsarch.h"

#pragma comment(lib, "libbsarch")

static const std::wstring separators(L"\\/");

std::wstring dirname(const std::wstring& path) {
  size_t slash_pos = path.find_last_of(separators);
  return path.substr(0, slash_pos);
}

std::wstring basename(const std::wstring& path) {
  size_t slash_pos = path.find_last_of(separators);
  return path.substr(slash_pos + 1);
}

bool mkdirp(const std::wstring& directory, bool basedir = true) {
  DWORD attributes = ::GetFileAttributesW(directory.c_str());
  if(attributes == INVALID_FILE_ATTRIBUTES) {
    std::size_t slash_pos = directory.find_last_of(separators);
    if(slash_pos != std::wstring::npos) {
      mkdirp(directory.substr(0, slash_pos));
    }
    return ::CreateDirectoryW(directory.c_str(), nullptr);
  } else {
    return true;
  }
}

int main() {
  bsa_result_message_t result = { 0 };
	bsa_archive_t archive = bsa_create();

  {
    result = bsa_load_from_file(archive, L"test_read.bsa");
    if(result.code < 0)
      printf("%ls\n", result.text);

    bsa_entry_list_t entries = bsa_entry_list_create();
    bsa_get_resource_list(archive, entries, L"");

    for(size_t index = 0; index < bsa_entry_list_count(entries); index++) {
      wchar_t filename[2048];
      bsa_entry_list_get(entries, index, 2048, filename);

      printf("file: %ls\n", filename);

      if(mkdirp(dirname(filename))) {
        result = bsa_extract_file(archive, filename, filename);
        if(result.code < 0)
          printf("%ls\n", result.text);
      } else {
        printf("could not create: %ls\n", dirname(filename).c_str());
      }
    }

    bsa_entry_list_free(entries);

    bsa_close(archive);
  }

  {
    bsa_entry_list_t entries = bsa_entry_list_create();
    bsa_entry_list_add(entries, L"textures\\grass\\test.dds");
    bsa_entry_list_add(entries, L"textures\\grass\\test2.dds");

    bsa_create_archive(archive, L"test_write.bsa", baSSE, entries);
    bsa_add_file_from_disk_root(archive, L"", L"textures\\grass\\test.dds");
    result = bsa_add_file_from_disk(archive, L"textures\\grass\\test2.dds", L"textures\\grass\\test.dds");
    if (result.code < 0)
      printf("%ls\n", result.text);
    bsa_save(archive);
    bsa_close(archive);

    bsa_entry_list_free(entries);
  }

	bsa_free(archive);
}
