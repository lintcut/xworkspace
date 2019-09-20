#include "xpch.h"

DRIVER_INITIALIZE DriverEntry;

NTSTATUS
DriverEntry(
  PDRIVER_OBJECT DriverObject,
  PUNICODE_STRING RegistryPath
)
{
    PAGED_CODE();
    return STATUS_SUCCESS;
}
