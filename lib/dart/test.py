import sys, os
import importlib
import thrift
from thrift.transport import TTransport
from thrift.Thrift import TType
from thrift.protocol import TJSONProtocol as ThriftProtocol

# to build the config classes:
# > thrift -gen py test.thrift
# this will generated the class code in the gen-py directory
# this line adds the gen-py directory to the python path so that we can import the generated classes
sys.path.append('./gen-py')

# namespace is from the thrift file. The namespace determines the directory structure of the generated code
namespace = 'Ballers.Config'

# import the generated classes
ConfigModule = importlib.import_module('%s.ttypes' % (namespace))

# create the test data
Header = ConfigModule.Header()
Header.schemaVersion = 1
Header.configVersion = 2

# create a memory buffer to write the data into
transport = TTransport.TMemoryBuffer()
# create a protocol to write the data into the memory buffer in json format
protocol = ThriftProtocol.TJSONProtocol(transport)
# write the test data
Header.write(protocol)

# save the data to a file
configPath = 'config_data.bin'
buf = transport.getvalue()
with open(configPath, 'wb') as f:
	f.write(buf)

buf = None

# load the file
with open(configPath, 'rb') as f:
	buf = f.read()

# read and validate the test data from the file data
transport = TTransport.TMemoryBuffer(buf)
protocol = ThriftProtocol.TJSONProtocol(transport)
Header = None
Header = ConfigModule.Header()
Header.read(protocol)
Header.validate()
print("Header.schemaVersion: %s" % Header.schemaVersion)
print("Header.configVersion: %s" % Header.configVersion)
