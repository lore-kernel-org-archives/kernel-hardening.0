From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 10:40:53 +1100
Message-Id: <1511826058-2563-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/5] add printk specifier %px, unique identifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Linus,

I know you are bored of this patch set already and this pits your vast
experience against my eight months kernel dev experience ;)

I humbly maintain that hashing %p and suggesting people use %x
_correctly_ isn't a WIN solution.

Please don't go easy on me because I'm new, if I'm out of line - say
so.

This set is based on the following assumptions.

1. We now have leaking_addresses.pl illuminating leaking addresses.
2. We have no _clear_ strategy for fixing leaks once found.
3. We do not have a proposed non opt-in solution.
4. There is a distinct use case for this specifier.

Patch 1: Corrects the docs for %pK.

Patch 2: Refactors %pK code out of pointer() into helper function.

Patch 3: Adds specifier %px, small 'x' was chosen because the hashed hex
         value is printed in lower case.

Patch 4/5: Provides example usage of new specifier.

The hashing code is based on the work done hashing %p during 4.14 dev
cycle.

Finally, with this patch set in place, we have the added benefit that
newbies (me) can quietly go around the kernel 'sweeping up' after
leaking addresses. This as apposed to using a hammer and hashing all
%p. And if this is deemed too little and too slow we can always search
and replace '%p' with '%px'.

thanks,
Tobin.

Tobin C. Harding (5):
  docs: correct documentation for %pK
  vsprintf: refactor pK code out of pointer()
  vsprintf: add specifier %px, unique identifier
  KVM: use %px to print token identifier
  vfio_pci: use %px to print token identifier

 Documentation/printk-formats.txt  |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c |   2 +-
 lib/test_printf.c                 |  74 +++++++++++++++++
 lib/vsprintf.c                    | 166 ++++++++++++++++++++++++++++----------
 scripts/checkpatch.pl             |   2 +-
 virt/kvm/eventfd.c                |   2 +-
 6 files changed, 202 insertions(+), 46 deletions(-)

-- 
2.7.4
