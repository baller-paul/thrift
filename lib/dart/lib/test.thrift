namespace py Ballers.Config
namespace dart ballers.config

struct Banger {
	1: required string id
	2: optional string display
	3: optional double balance
	4: required double wickedness
}

struct Header
{
	1: required i32 schemaVersion
	2: required i32 configVersion
	3: required Banger banger
	4: optional i32 optionalInt
	5: optional string optionalString
}
