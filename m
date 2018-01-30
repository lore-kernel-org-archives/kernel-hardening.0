Subject: [PATCH v6 00/13] spectre variant1 mitigations for tip/x86/pti
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:02:10 -0800
Message-ID: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, mingo@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Cyril Novikov <cnovikov@lynx.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, alan@linux.intel.com, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Thomas, Ingo,

Here is another spin of the Spectre variant1 mitigations.

Changes since v5 [1]:
* Use the _nospec suffix for all new infrastructure, i.e.
  s/ifence/barrier_nospec/, s/array_idx/array_index_nospec/,
  and s/array_idx_mask/array_index_mask_nospec/. (Ingo)

* Fix up array_index_mask_nospec() to have a proper kernel doc comment
  (Thomas)

* Fix up copyright attribution in include/linux/nospec.h (Ingo)

* Spell out 'index' and 'size' throughout the patch set rather than
  'idx' and 'sz'. (Ingo).

* Clarify placement of barrier_nospec() relative to stac() in
  __uaccess_begin_nospec() (Ingo)

* Drop the syscall fast path elimination patch out of this series since
  Andy is handling that separately. (Andy)

* Simplify the x86 array_index_mask_nospec() assembly, no need for a
  separate 32-bit version (Ingo)

* Clarify that the 'cmp, sbb' sequence in the get_user_<size> variants
  are effectively open coded array_index_nospec() instances where the
  array base is the user pointer and the array limit is the task address
  limit. (Ingo)

* Replace '<function identifier>' with <function identifier>()
  throughout the series. (Ingo)

* Comment and whitespace fixups in asm/barrier.h (Ingo)

* Split the definition of barrier_nospec() into its own patch separate
  from its new usages with __uaccess_begin_nospec(). (Ingo)

* Split the __uaccess_begin_nospec() patch into one that cleans up open
  coded stac/clac usage and one that uses the new
  __uaccess_begin_nospec() helper. (Ingo)

* Change the contents of the 'bug/spectre_v1' sysfs file to:
  "Mitigation: __user pointer sanitization" since these changes do raise
  the kernel's defenses. (Ingo)

[1]: https://www.spinics.net/lists/linux-arch/msg44193.html

---

Dan Williams (12):
      array_index_nospec: sanitize speculative array de-references
      x86: implement array_index_mask_nospec
      x86: introduce barrier_nospec
      x86: introduce __uaccess_begin_nospec
      x86, usercopy: replace open coded stac/clac with __uaccess_{begin,end}
      x86, __get_user: use __uaccess_begin_nospec
      x86, get_user: use pointer masking to limit speculation
      x86: sanitize syscall table de-references under speculation
      vfs, fdtable: prevent bounds-check bypass via speculative execution
      kvm, x86: update spectre-v1 mitigation
      nl80211: sanitize array index in parse_txq_params
      x86/spectre: report get_user mitigation for spectre_v1

Mark Rutland (1):
      Documentation: document array_index_nospec


 Documentation/speculation.txt     |   90 +++++++++++++++++++++++++++++++++++++
 arch/x86/entry/common.c           |    5 ++
 arch/x86/include/asm/barrier.h    |   28 ++++++++++++
 arch/x86/include/asm/msr.h        |    3 -
 arch/x86/include/asm/uaccess.h    |   15 +++++-
 arch/x86/include/asm/uaccess_32.h |    6 +-
 arch/x86/include/asm/uaccess_64.h |   12 ++---
 arch/x86/kernel/cpu/bugs.c        |    2 -
 arch/x86/kvm/vmx.c                |   14 ++++--
 arch/x86/lib/getuser.S            |   10 ++++
 arch/x86/lib/usercopy_32.c        |    8 ++-
 include/linux/fdtable.h           |    5 ++
 include/linux/nospec.h            |   72 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c            |    9 ++--
 14 files changed, 251 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/speculation.txt
 create mode 100644 include/linux/nospec.h
