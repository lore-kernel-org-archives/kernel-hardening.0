From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 13:05:58 -0800
Message-ID: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4.1 00/10] spectre variant1 mitigations for tip/x86/pti
To: tglx@linutronix.de
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, alan@linux.intel.com, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Thomas,

Please consider taking this collection of spectre-v1 mitigations through
the tip/x86/pti branch for 4.16 inclusion. The review feedback has
dropped off considerably, so I believe these patches are ready for -tip
inclusion. However, "nl80211: sanitize array index in parse_txq_params"
stands out as a patch that should get an ack from net/wireless folks
before moving forward.

Also a heads up that x86/pti is missing commit 75f139aaf896 "KVM: x86:
Add memory barrier on vmcs field lookup", so you will hit a trivial
conflict merging "kvm, x86: update spectre-v1 mitigation" from this set
against latest mainline.

The infrastructure includes:

* __uaccess_begin_nospec: similar to __uaccess_begin this invokes
'stac', but it also includes an 'ifence'. After an 'access_ok' check
has speculatively succeeded that result needs to be retired before the
user pointer is de-referenced. '__get_user' can't use the pointer
sanitization approach without redoing the 'access_ok' check, so per
Linus [1] just use 'ifence'.

* MASK_NOSPEC: an assembler macro for x86 'get_user' and syscall entry
that sanitizes a user controlled pointer or array index to zero after a
'cmp %limit %val' instruction sets the CF flag.

* array_ptr: When dereferencing a kernel pointer with a user controlled
index, sanitize the pointer to either NULL or valid addresses under
speculation to eliminate a precondition for Spectre variant1 attacks.
It uses a mask generation technique that does not involve speculative
control flows on either x86 or ARM64 [2].

* x86 array_ptr_mask: Achieve the same effect as the default
'array_ptr_mask' in fewer instructions. This approach does not have the
same "array index and limit must be less than LONG_MAX" constraint as
the default mask.

* array_idx: Similar to 'array_ptr', use a mask to return a valid
pointer or NULL to an array index variable. An example where we need
this is the wireless driver stack where the core sanitizes user input
and the actual usage of the array index is in a different compilation
unit in the low-level driver.

[1]: https://lkml.org/lkml/2018/1/17/929
[2]: https://www.spinics.net/lists/netdev/msg477542.html

---

Dan Williams (9):
      asm/nospec, array_ptr: sanitize speculative array de-references
      x86: implement array_ptr_mask()
      x86: introduce __uaccess_begin_nospec and ifence
      x86, __get_user: use __uaccess_begin_nospec
      x86, get_user: use pointer masking to limit speculation
      x86: narrow out of bounds syscalls to sys_read under speculation
      vfs, fdtable: prevent bounds-check bypass via speculative execution
      kvm, x86: update spectre-v1 mitigation
      nl80211: sanitize array index in parse_txq_params

Mark Rutland (1):
      Documentation: document array_ptr


 Documentation/speculation.txt     |  143 +++++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S         |    2 +
 arch/x86/include/asm/barrier.h    |   28 +++++++
 arch/x86/include/asm/msr.h        |    3 -
 arch/x86/include/asm/smap.h       |   24 ++++++
 arch/x86/include/asm/uaccess.h    |   15 +++-
 arch/x86/include/asm/uaccess_32.h |    6 +-
 arch/x86/include/asm/uaccess_64.h |   12 ++-
 arch/x86/kvm/vmx.c                |   11 ++-
 arch/x86/lib/getuser.S            |    5 +
 arch/x86/lib/usercopy_32.c        |    8 +-
 include/linux/fdtable.h           |    7 +-
 include/linux/nospec.h            |   65 +++++++++++++++++
 net/wireless/nl80211.c            |   10 ++-
 14 files changed, 312 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/speculation.txt
 create mode 100644 include/linux/nospec.h
