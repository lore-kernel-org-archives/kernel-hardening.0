From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 11 Oct 2017 10:09:31 +1100
Message-Id: <1507676974-1298-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/3] add %pX specifier
To: kernel-hardening@lists.openwall.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This series is a result of the recent thread on LKML regarding kpt_restrict

https://lkml.org/lkml/2017/9/30/224

It seems we have not reached total consensus. This patch set does not claim to solve the whole issue
but rather take a small step forward without taking any steps backwards.

It may be that, since this issue is security related, there is no total solution only trade offs?

I am quite new to kernel development, which implies, neither am I a kernel security expert. In order
that my understanding of the issue is explicit I am listing here the things we all seem to agree on.

1. We are leaking addresses.

2. There are _some_ use cases for printing addresses.

3. Printing kernel pointers with %p and %x is bad.

4. We could reduce the number of leaked addresses if we had a mechanism to print unique identifiers.

If I am badly mistaken please feel free to yell at me, here to learn, happy to be corrected.

This patch set solves point 4 (above) by adding a printk specifier %pX to print a unique identifier
(hash) based on a pointer. This was suggested by Linus (in the above thread) as; 

  +        hashval = hash_three_words(
  +                (unsigned long)ptr,
  +                (unsigned long)ptr >> 16 >> 16,
  +                boot_time_random_int);


I did not understand the code (specifically why the right shift of 16 twice?). I therefore chose to
use an algorithm from kernel/kcmp.h for creating the hash (suggested by Tycho Anderson).

This patch is a softer version of Linus' suggestion because it does not change the behaviour of the
%p specifier. I don't see the benefit in making such a breaking change without addressing the issue
of %x (and I don't the balls to right now).

Patch 2 and 3 of the series give an example usage of the new specifier.

Thanks for taking the time to read this. All criticism and advice willingly accepted. 

thanks,
Tobin.


Tobin C. Harding (3):
  lib/vsprintf: add 'X' specifier to hash pointers
  KVM: use %pX to print token identifier
  vfio_pci: use %pX to print token identifier

 Documentation/printk-formats.txt  |  9 +++++++++
 drivers/vfio/pci/vfio_pci_intrs.c |  2 +-
 include/linux/printk.h            | 17 +++++++++++++++++
 lib/vsprintf.c                    | 33 +++++++++++++++++++++++++++++++++
 scripts/checkpatch.pl             |  2 +-
 virt/kvm/eventfd.c                |  2 +-
 6 files changed, 62 insertions(+), 3 deletions(-)

-- 
2.7.4
