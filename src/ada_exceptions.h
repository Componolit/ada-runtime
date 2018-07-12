// AUTOGENERATED, edit doc/exceptions.md

typedef enum {
    UNDEFINED_EXCEPTION = 0x0,
    CE_EXPLICIT_RAISE = 0x100,
    CE_ACCESS_CHECK = 0x101,
    CE_NULL_ACCESS_PARAMETER = 0x102,
    CE_DISCRIMINANT_CHECK = 0x103,
    CE_DIVIDE_BY_ZERO = 0x104,
    CE_INDEX_CHECK = 0x105,
    CE_INVALID_DATA = 0x106,
    CE_LENGTH_CHECK = 0x107,
    CE_NULL_EXCEPTION_ID = 0x108,
    CE_NULL_NOT_ALLOWED = 0x109,
    CE_OVERFLOW_CHECK = 0x10a,
    CE_PARTITION_CHECK = 0x10b,
    CE_RANGE_CHECK = 0x10c,
    CE_TAG_CHECK = 0x10d,
    PE_EXPLICIT_RAISE = 0x200,
    PE_ACCESS_BEFORE_ELABORATION = 0x201,
    PE_ACCESSIBILITY_CHECK = 0x202,
    PE_ADDRESS_OF_INTRINSIC = 0x203,
    PE_ALIASED_PARAMETERS = 0x204,
    PE_ALL_GUARDS_CLOSED = 0x205,
    PE_BAD_PREDICATED_GENERIC_TYPE = 0x206,
    PE_CURRENT_TASK_IN_ENTRY_BODY = 0x207,
    PE_DUPLICATED_ENTRY_ADDRESS = 0x208,
    PE_IMPLICIT_RETURN = 0x209,
    PE_MISALIGNED_ADDRESS_VALUE = 0x20a,
    PE_MISSING_RETURN = 0x20b,
    PE_OVERLAID_CONTROLLED_OBJECT = 0x20c,
    PE_NON_TRANSPORTABLE_ACTUAL = 0x20d,
    PE_POTENTIALLY_BLOCKING_OPERATION = 0x20e,
    PE_STREAM_OPERATION_NOT_ALLOWED = 0x20f,
    PE_STUBBED_SUBPROGRAM_CALLED = 0x210,
    PE_UNCHECKED_UNION_RESTRICTION = 0x211,
    PE_FINALIZE_RAISED_EXCEPTION = 0x212,
    SE_EXPLICIT_RAISE = 0x300,
    SE_EMPTY_STORAGE_POOL = 0x301,
    SE_INFINITE_RECURSION = 0x302,
    SE_OBJECT_TOO_LARGE = 0x303
} exception_t;
