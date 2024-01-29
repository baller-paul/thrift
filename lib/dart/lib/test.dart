import 'dart:io';
import 'dart:typed_data';

import 'package:thrift/thrift.dart';

import 'gen-dart/test/lib/src/header.dart';

// To build the config classes:
// > thrift -gen dart test.thrift
// this will generated the class code in the gen-dart directory

void main() async {
  // Initialize Header object with test data
  var header = Header()
    ..schemaVersion = 1
    ..configVersion = 3;

  // Prepare a buffer to hold serialized data
  var byteBuffer = BytesBuilder();

  // Setup transport and protocol for serialization
  var transport = TBufferedTransport()..open();
  var protocol = TJsonProtocol(transport);

  // Serialize the header object into the transport
  header.write(protocol);
  // Ensure all data is written to the transport's internal buffer
  await transport.flush();

  // Retrieve serialized data from the transport and add it to the byte buffer
  byteBuffer.add(transport.consumeWriteBuffer());

  // Define the path for the output file and write the buffer to the file
  var configPath = 'config_data.bin';
  Uint8List? buf = byteBuffer.toBytes();
  var file = File(configPath);
  await file.writeAsBytes(buf);

  // Clear the buffer variable
  buf = null;

  // Read the serialized data back from the file
  buf = await File(configPath).readAsBytes();

  // Close the previous transport instance
  transport.close();

  // Setup a new transport and load the read data into it for deserialization
  transport = TBufferedTransport()..open();
  transport.writeAll(buf);
  // Process the loaded data
  await transport.flush();

  // Setup a new protocol instance for deserialization
  protocol = TJsonProtocol(transport);

  // Deserialize the data into a new Header object
  var newHeader = Header();
  newHeader.read(protocol);

  // Read the deserialized data
  print("Header.schemaVersion: ${newHeader.schemaVersion}");
  print("Header.configVersion: ${newHeader.configVersion}");
}
