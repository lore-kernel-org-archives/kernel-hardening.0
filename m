From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu, 26 Oct 2017 13:53:54 +1100
Message-Id: <1508986436-31966-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V8 0/2] printk: hash addresses printed with %p
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

With this version we include hashing of malformed specifiers also.
Malformed specifiers include incomplete (e.g %pi) and also non-existent
specifiers. checkpatch should warn for non-existent specifiers but
AFAICT won't warn for incomplete specifiers.

Here is the behaviour that this set implements.

For kpt_restrict==0

Randomness not ready:
  printed with %p: 		(pointer)          # NOTE: with padding
Valid pointer:
  printed with %pK: 		deadbeefdeadbeef
  printed with %p: 		0xdeadbeef
  malformed specifier (eg %i):  0xdeadbeef
NULL pointer:
  printed with %pK: 		0000000000000000
  printed with %p: 		(null)               # NOTE: no padding
  malformed specifier (eg %i):  (null)

For kpt_restrict==2

Valid pointer:
  printed with %pK: 		0000000000000000

All other output as for kptr_restrict==0

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
  printk: remove tabular output for NULL pointer
  printk: hash addresses printed with %p

 lib/vsprintf.c | 166 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 108 insertions(+), 58 deletions(-)

-- 
2.7.4
