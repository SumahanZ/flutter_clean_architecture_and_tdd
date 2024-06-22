//mimick the json returned by a server and read it

import 'dart:io';

String fixture(String fileName) => File(fileName).readAsStringSync();
