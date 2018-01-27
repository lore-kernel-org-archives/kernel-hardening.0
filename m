MIME-Version: 1.0
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jan 2018 11:26:37 -0800
Message-ID: <CAPcyv4hZ0axyyzpRb1+fETXZOzgzM1v4mgsYM_FKqCAdKNAbSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 00/12] spectre variant1 mitigations for tip/x86/pti
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, Alan Cox <alan@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

[ adding lkml ]

I had inadvertently dropped lkml when sending this to Thomas. Archive here:

https://marc.info/?l=linux-wireless&m=151704026325010&w=2
https://marc.info/?l=linux-arch&m=151704027225013&w=2
https://marc.info/?l=linux-arch&m=151704027225014&w=2
https://marc.info/?l=linux-arch&m=151704027625015&w=2
https://marc.info/?l=linux-arch&m=151704028225016&w=2
https://marc.info/?l=linux-arch&m=151704028725019&w=2
https://marc.info/?l=linux-arch&m=151704086725186&w=2
https://marc.info/?l=linux-arch&m=151704030025025&w=2
https://marc.info/?l=linux-arch&m=151704030525028&w=2
https://marc.info/?l=linux-arch&m=151704031125029&w=2
https://marc.info/?l=linux-arch&m=151704032225034&w=2
https://marc.info/?l=linux-arch&m=151704032625035&w=2
https://marc.info/?l=linux-arch&m=151704032725037&w=2


On Fri, Jan 26, 2018 at 11:55 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Hi Thomas,
>
> Here's another spin of the spectre-v1 mitigations for 4.16.
>
> Changes since v4.1: [1]
> * Tweak the sanitization scheme yet again to make it even simpler. Now,
>   instead of 'array_ptr' to get a sanitized pointer to an array element,
>   just provide an array index sanitization helper 'array_idx' to be called
>   after successfully validating the index is in bounds. I.e. in the
>   exact same location one would otherwise put an lfence, place this
>   sanitizer:
>
>       if (idx < sz) {
>           idx = array_idx(idx, sz);
>           val = array[idx];
>       }
>
>   This lets the implementation include more sanity checking that the
>   compiler can usually compile out. It otherwise appears to produce
>   better assembly. This also cleans up the concern about comparing the
>   value returned from array_ptr to create another speculation point.
>   (Russell, Linus, Cyril)
>
> * Drop the syscall_64_fastpath.  This is the straightforward patch from
>   Linus that might also be in flight from Andy, but I went ahead and
>   included it since I did not see it on LKML yet.
>
> * Kill the MASK_NOSPEC macro and just open code it. (Andy)
>
> * Add system-call-number sanitization to the slow path syscall table
>   lookups.
>
> * Redo the array_ptr conversions with array_idx.
>
> * Update /sys/devices/system/cpu/vulnerabilities/spectre_v1 to indicate
>   the new protections. It now reports "Vulnerable: Minimal user pointer
>   sanitization". (Jiri)
>
> ---
>
> Dan Williams (11):
>       array_idx: sanitize speculative array de-references
>       x86: implement array_idx_mask
>       x86: introduce __uaccess_begin_nospec and ifence
>       x86, __get_user: use __uaccess_begin_nospec
>       x86, get_user: use pointer masking to limit speculation
>       x86: remove the syscall_64 fast-path
>       x86: sanitize sycall table de-references under speculation
>       vfs, fdtable: prevent bounds-check bypass via speculative execution
>       kvm, x86: update spectre-v1 mitigation
>       nl80211: sanitize array index in parse_txq_params
>       x86/spectre: report get_user mitigation for spectre_v1
>
> Mark Rutland (1):
>       Documentation: document array_idx
>
>
>  Documentation/speculation.txt     |   87 ++++++++++++++++++++++++++++
>  arch/x86/entry/common.c           |    3 +
>  arch/x86/entry/entry_64.S         |  116 -------------------------------------
>  arch/x86/entry/syscall_64.c       |    7 +-
>  arch/x86/include/asm/barrier.h    |   26 ++++++++
>  arch/x86/include/asm/msr.h        |    3 -
>  arch/x86/include/asm/uaccess.h    |   15 ++++-
>  arch/x86/include/asm/uaccess_32.h |    6 +-
>  arch/x86/include/asm/uaccess_64.h |   12 ++--
>  arch/x86/kernel/cpu/bugs.c        |    2 -
>  arch/x86/kvm/vmx.c                |   14 +++-
>  arch/x86/lib/getuser.S            |   10 +++
>  arch/x86/lib/usercopy_32.c        |    8 +--
>  include/linux/fdtable.h           |    5 +-
>  include/linux/nospec.h            |   64 ++++++++++++++++++++
>  net/wireless/nl80211.c            |    9 ++-
>  16 files changed, 239 insertions(+), 148 deletions(-)
>  create mode 100644 Documentation/speculation.txt
>  create mode 100644 include/linux/nospec.h
