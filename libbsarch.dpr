library libbsarch;

uses
  Math,
  Classes,
  Types,
  SysUtils,
  wbStreams in 'wbStreams.pas',
  wbBSArchive in './wbBSArchive.pas';

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

{Shared}

function string_to_cstring(aString: String; const aStringBufferSize: Cardinal;
  const aStringBuffer: PChar): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := Min(aStringBufferSize, Length(AString));
  if (aStringBuffer <> nil) and (Result > 0) then
    Move(AString[1], aStringBuffer^, Result * SizeOf(Char));
end;

{BSA File List}

function bsa_entry_list_create:Pointer; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSEntryList.Create;
end;

procedure bsa_entry_list_free(obj: Pointer); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSEntryList(obj).Clear();
  TwbBSEntryList(obj).free;
end;

function bsa_entry_list_count(obj: Pointer): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSEntryList(obj).Count;
end;

procedure bsa_entry_list_add(obj: Pointer; const aEntryString: PChar); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSEntryList(obj).Add(String(aEntryString));
end;

function bsa_entry_list_get(obj: Pointer; const aIndex: Cardinal; const aStringBufferSize: Cardinal; const aStringBuffer: PChar): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := string_to_cstring(TwbBSEntryList(obj).Strings[aIndex], aStringBufferSize, aStringBuffer);
end;

{BSArchive}

function bsa_create:Pointer; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive.Create;
end;

procedure bsa_free(obj: Pointer); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).free;
end;

procedure bsa_load_from_file(obj: Pointer; const aFileName: PChar); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).LoadFromFile(String(aFileName));
end;

procedure bsa_create_archive(obj: Pointer; const aFileName: PChar; aType: TBSArchiveType; aFileList: TwbBSEntryList); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).CreateArchiveCompat(String(aFileName), aType, aFileList);
end;

procedure bsa_save(obj: Pointer); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).Save;
end;

procedure bsa_add_file_from_disk(obj: Pointer; const aRootDir, aFileName: PChar); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).AddFile(String(aRootDir), String(aFileName));
end;

procedure bsa_add_file_from_memory(obj: Pointer; const aFileName: PChar; const aSize: Cardinal; const aData: PByte); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).AddFileCompat(String(aFileName), aSize, aData);
end;

function bsa_find_file_record(obj: Pointer; const aFileName: PChar): Pointer; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).FindFileRecord(String(aFileName));
end;

function bsa_extract_file_data_by_record(obj: Pointer; aFileRecord: Pointer): TwbBSFileDataResult; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).ExtractFileDataCompat(aFileRecord);
end;

function bsa_extract_file_data_by_filename(obj: Pointer; const aFileName: PChar): TwbBSFileDataResult; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).ExtractFileDataCompat(String(aFileName));
end;

procedure bsa_file_data_free(obj: Pointer; fileDataResult: TwbBSFileDataResult); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ReleaseFileDataCompat(fileDataResult);
end;

procedure bsa_extract_file(obj: Pointer; const aFileName, aSaveAs: PChar); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ExtractFile(String(aFileName), String(aSaveAs));
end;

procedure bsa_iterate_files(obj: Pointer; aProc: TBSFileIterationProcCompat; aContext: Pointer); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).IterateFilesCompat(aProc, aContext);
end;

function bsa_file_exists(obj: Pointer; const aFileName: string): Boolean; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).FileExists(aFileName);
end;

procedure bsa_get_resource_list(obj: Pointer; const aEntryResultList: TwbBSEntryList; aFolder: PChar); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ResourceListCompat(aEntryResultList, String(aFolder));
end;

procedure bsa_resolve_hash(obj: Pointer; const aHash: UInt64; const aEntryResultList: TwbBSEntryList); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ResolveHashCompat(aHash, aEntryResultList);
end;

procedure bsa_close(obj: Pointer); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).Close;
end;

function bsa_filename_get(obj: Pointer; const aStringBufferSize: Cardinal; const aStringBuffer: PChar): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := string_to_cstring(TwbBSArchive(obj).FileName, aStringBufferSize, aStringBuffer);
end;

function bsa_archive_type_get(obj: Pointer): TBSArchiveType; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).ArchiveType;
end;

function bsa_version_get(obj: Pointer): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).Version;
end;

function bsa_format_name_get(obj: Pointer; const aStringBufferSize: Cardinal; const aStringBuffer: PChar): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := string_to_cstring(TwbBSArchive(obj).FormatName, aStringBufferSize, aStringBuffer);
end;

function bsa_file_count_get(obj: Pointer): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).FileCount;
end;

function bsa_archive_flags_get(obj: Pointer): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).ArchiveFlags;
end;

procedure bsa_archive_flags_set(obj: Pointer; flags: Cardinal); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ArchiveFlags := flags;
end;

function bsa_file_flags_get(obj: Pointer): Cardinal; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).FileFlags;
end;

procedure bsa_file_flags_set(obj: Pointer; flags: Cardinal); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).FileFlags := flags;
end;

function bsa_compress_get(obj: Pointer): Boolean; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).Compress;
end;

procedure bsa_compress_set(obj: Pointer; compress: Boolean); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).Compress := compress;
end;

function bsa_share_data_get(obj: Pointer): Boolean; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := TwbBSArchive(obj).ShareData;
end;

procedure bsa_share_data_set(obj: Pointer; shareData: Boolean); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).ShareData := shareData;
end;

procedure bsa_file_dds_info_callback_set(obj: Pointer; aProc: TBSFileDDSInfoProcCompat); {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  TwbBSArchive(obj).DDSInfoProc := aProc;
end;

exports
  bsa_entry_list_create,
  bsa_entry_list_free,
  bsa_entry_list_count,
  bsa_entry_list_add,
  bsa_entry_list_get,

  bsa_filename_get,
  bsa_archive_type_get,
  bsa_version_get,
  bsa_format_name_get,
  bsa_file_count_get,
  bsa_archive_flags_get,
  bsa_archive_flags_set,
  bsa_file_flags_get,
  bsa_file_flags_set,
  bsa_compress_get,
  bsa_compress_set,
  bsa_share_data_get,
  bsa_share_data_set,
  bsa_file_dds_info_callback_set,

  bsa_close,
  bsa_resolve_hash,
  bsa_get_resource_list,
  bsa_file_exists,
  bsa_iterate_files,
  bsa_extract_file,
  bsa_file_data_free,
  bsa_extract_file_data_by_filename,
  bsa_extract_file_data_by_record,
  bsa_find_file_record,
  bsa_add_file_from_memory,
  bsa_add_file_from_disk,
  bsa_save,
  bsa_create_archive,
  bsa_load_from_file,
  bsa_create,
  bsa_free
  ;
end.
