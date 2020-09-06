#!/usr/bin/env python3
import sys
print('hi from python {}.{}.{} running on {}'.format(
    sys.version_info.major,
    sys.version_info.minor,
    sys.version_info.micro,
    sys.platform,
))
