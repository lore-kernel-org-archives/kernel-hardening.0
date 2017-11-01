From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  1 Nov 2017 15:32:21 +1100
Message-Id: <1509510743-28429-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V10 0/2] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently there are many places in the kernel where addresses are being
printed using an unadorned %p. Kernel pointers should be printed using
%pK allowing some control via the kptr_restrict sysctl. Exposing
addresses gives attackers sensitive information about the kernel layout
in memory.

We can reduce the attack surface by hashing all addresses printed with
%p. This will of course break some users, forcing code printing needed
addresses to be updated.

This version adds testing, this is my first effort at kernel unit
testing. Modules in `lib` don't seem contained within a selftest target
so in order to incrementally develop the tests I implemented the tests
in `lib/test_printf.c`, built with `make M=lib` and then to insert the
module, instead of running selftest, I spun up a VM and inserted the
module manually. Comments or suggestions much appreciated.

Here is the behaviour that this series implements.

For kpt_restrict==0

Randomness not ready:
  printed with %p:                     (ptrval)     # NOTE: with padding
Valid pointer:
  printed with %pK:             deadbeefdeadbeef
  printed with %p:              00000000deadbeef
  malformed specifier (eg %i):  00000000deadbeef
NULL pointer:
  printed with %pK:             0000000000000000
  printed with %p:                       (null)     # NOTE: with padding
  malformed specifier (eg %i):           (null)

For kpt_restrict==2

Valid pointer:
  printed with %pK:             0000000000000000

All other output as for kptr_restrict==0

V10:
 - Add patch so KASAN uses %pK instead of %p. 
 - Add documentation to Documentation/printk-formats.txt
 - Add tests to lib/test_printf.c
 - Change "(pointer value)" -> "(ptrval)" to fit within columns on 32
   bit machines.

V9:
 - Drop the initial patch from V8, leaving null pointer handling as is.
 - Print the hashed ID _without_ a '0x' suffix.
 - Mask the first 32 bits of the hashed ID to all zeros on 64 bit
   architectures.

V8:
 - Add second patch cleaning up null pointer printing in pointer()
 - Move %pK handling to separate function, further cleaning up pointer()
 - Move ptr_to_id() call outside of switch statement making hashing
   the default behaviour (including malformed specifiers).
 - Remove use of static_key, replace with simple boolean.

V7:
 - Use tabs instead of spaces (ouch!).

V6:
 - Use __early_initcall() to fill the SipHash key.
 - Use static keys to guard hashing before the key is available.

V5:
 - Remove spin lock.
 - Add Jason A. Donenfeld to CC list by request.
 - Add Theodore Ts'o to CC list due to comment on previous version.

V4:
 - Remove changes to siphash.{ch}
 - Do word size check, and return value cast, directly in ptr_to_id().
 - Use add_ready_random_callback() to guard call to get_random_bytes()

V3:
 - Use atomic_xchg() to guard setting [random] key.
 - Remove erroneous white space change.

V2:
 - Use SipHash to do the hashing.

The discussion related to this patch has been fragmented. There are
three threads associated with this patch. Email threads by subject:

[PATCH] printk: hash addresses printed with %p
[PATCH 0/3] add %pX specifier
[kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options

Tobin C. Harding (2):
  kasan: use %pK to print addresses instead of %p
  printk: hash addresses printed with %p

 Documentation/printk-formats.txt |  17 +++-
 lib/test_printf.c                | 108 +++++++++++++++---------
 lib/vsprintf.c                   | 176 ++++++++++++++++++++++++++++-----------
 mm/kasan/report.c                |   8 +-
 4 files changed, 217 insertions(+), 92 deletions(-)

-- 
2.7.4
