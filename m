From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 29 Nov 2017 13:05:00 +1100
Message-Id: <1511921105-3647-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V11 0/5] hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently there exist approximately 14 000 places in the Kernel where
addresses are being printed using an unadorned %p. This potentially
leaks sensitive information regarding the Kernel layout in memory. Many
of these calls are stale, instead of fixing every call lets hash the
address by default before printing. This will of course break some
users, forcing code printing needed addresses to be updated. We can add
a printk specifier for this purpose (%px) to give developers a clear
upgrade path for breakages caused by applying this patch set.

The added advantage of hashing %p is that security is now opt-out, if
you _really_ want the address you have to work a little harder and use
%px.

The idea for creating the printk specifier %px to print the actual
address was suggested by Kees Cook (see below for email threads by
subject).

Newbie question: I don't know who is potentially going to want to apply
this, I've CC'd Andrew Morton. I'm guessing this should go into
linux-next so we can see what breaks? I do not know exactly how code
gets into linux-next. I've CC'd Stephen Rothwell.

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

V11:
 - Add patch fixing %pK documentation.
 - Refactor %pK as a separate patch.
 - Add patch adding printk specifier %px, which prints the actual
   address (i.e replaces original %p behaviour). 
 - Use %px for KASAN patch.

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

[PATCH 0/5] add printk specifier %px, unique identifier
[PATCH] printk: hash addresses printed with %p
[PATCH 0/3] add %pX specifier
[kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options

Tobin C. Harding (5):
  docs: correct documentation for %pK
  vsprintf: refactor %pK code out of pointer()
  printk: hash addresses printed with %p
  vsprintf: add printk specifier %px
  kasan: use %px to print addresses instead of %p

 Documentation/printk-formats.txt |  31 ++++++-
 lib/test_printf.c                | 108 ++++++++++++++--------
 lib/vsprintf.c                   | 194 +++++++++++++++++++++++++++++----------
 mm/kasan/report.c                |   8 +-
 scripts/checkpatch.pl            |   2 +-
 5 files changed, 248 insertions(+), 95 deletions(-)

-- 
2.7.4
