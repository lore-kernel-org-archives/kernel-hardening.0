From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 0/6] lib: Add safe string funtions 
Date: Tue, 19 Feb 2019 10:23:02 +1100
Message-Id: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

No file maintainer, CC'ing all those who touched this file :) And
Shua for kselftest stuff.


Hi Kess,

During your talk at LCA you mentioned that we could do with a couple
more safe string functions.  One to zero the tail of the destination
buffer after call to strscpy() and also the self explanatory
strscpy_from_user().

Here is a patch set with my attempts to implement these two functions.

While doing this I noticed that we have a test module for lib/string.c
(lib/test_string.c) that is not tied into kselftest.  So I enable this
first up in patch 1.

Patch 2 and 3 are function docstring cleanups.

Patch 4 adds the copy and zero function, naming it strscpy_zeroed().
I'd love some help naming this better.  Patch also adds test code.

Patch 5 fixes function docstring to correctly document the behavior of
strncpy_from_user().

Patch 6 adds strscpy_from_user().  Does not include test code.

I had to do a bit of learning for getting the tests hooked into
kselftest, I think its all correct.  Module is built correctly when the
config option is present and the tests run both via

	make -C tools/testing/selftests TARGETS=lib run_tests

and via loading the module manually.  As a side note, this series leaves
tools/testing/selftests/lib with 4 shell scripts that are identical
except the test name.  We could probably do with refactoring them into a
single script.

Patchset introduces a checkpatch warning

	WARNING:CONFIG_DESCRIPTION: please write a paragraph that describes the config symbol fully

I couldn't work out if this is a false positive or not?  Does the new
config option CONFIG_TEST_STRING need more documentation?  I don't see
where extra docs should be added and it seems self explanatory as is.


thanks,
Tobin.

Tobin C. Harding (6):
  lib/string: Enable string selftesting
  lib/string: Fix erroneous 'overflow' documentation
  lib/string: Use correct docstring format
  lib/string: Add string copy/zero function
  lib: Fix function documentation for strncpy_from_user
  lib: Add function strscpy_from_user()

 include/linux/string.h                |  4 ++
 lib/Kconfig.debug                     | 14 +++++++
 lib/Makefile                          |  2 +-
 lib/string.c                          | 41 ++++++++++++++----
 lib/strncpy_from_user.c               | 60 ++++++++++++++++++++++-----
 lib/test_string.c                     | 35 +++++++++++++++-
 tools/testing/selftests/lib/Makefile  |  2 +-
 tools/testing/selftests/lib/config    |  1 +
 tools/testing/selftests/lib/string.sh | 19 +++++++++
 9 files changed, 157 insertions(+), 21 deletions(-)
 create mode 100755 tools/testing/selftests/lib/string.sh

-- 
2.20.1
