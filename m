From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Jan 2018 16:01:36 -0800
Message-ID: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4 00/10] prevent bounds-check bypass via speculative
 execution
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, alan@linux.intel.com, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, tglx@linutronix.de, akpm@linux-foundation.org, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org, stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Changes since v3 [1]
* Drop 'ifence_array_ptr' and associated compile-time + run-time
  switching and just use the masking approach all the time.

* Convert 'get_user' to use pointer sanitization via masking rather than
  lfence. '__get_user' and associated paths still rely on
  lfence. (Linus)

      "Basically, the rule is trivial: find all 'stac' users, and use
       address masking if those users already integrate the limit
       check, and lfence they don't."

* At syscall entry sanitize the syscall number under speculation
  to remove a user controlled pointer de-reference in kernel
  space.  (Linus)

* Fix a raw lfence in the kvm code (added for v4.15-rc8) to use
  'array_ptr'.

* Propose 'array_idx' as a way to sanitize user input that is
  later used as an array index, but where the validation is
  happening in a different code block than the array reference.
  (Christian).

* Fix grammar in speculation.txt (Kees)

---

Quoting Mark's original RFC:

"Recently, Google Project Zero discovered several classes of attack
against speculative execution. One of these, known as variant-1, allows
explicit bounds checks to be bypassed under speculation, providing an
arbitrary read gadget. Further details can be found on the GPZ blog [2]
and the Documentation patch in this series."

A precondition of using this attack on the kernel is to get a user
controlled pointer de-referenced (under speculation) in privileged code.
The primary source of user controlled pointers in the kernel is the
arguments passed to 'get_user' and '__get_user'. An example of other
user controlled pointers are user-controlled array / pointer offsets.

Better tooling is needed to find more arrays / pointers with user
controlled indices / offsets that can be converted to use 'array_ptr' or
'array_idx'. A few are included in this set, and these are not expected
to be complete. That said, the 'get_user' protections raise the bar on
finding a vulnerable gadget in the kernel.

These patches are also available via the 'nospec-v4' git branch here:

    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec-v4

Note that the BPF fix for Spectre variant1 is merged for 4.15-rc8.

[2]: https://googleprojectzero.blogspot.co.uk/2018/01/reading-privileged-memory-with-side.html

---

Dan Williams (9):
      asm/nospec, array_ptr: sanitize speculative array de-references
      x86: implement array_ptr_mask()
      x86: introduce __uaccess_begin_nospec and ifence
      x86, __get_user: use __uaccess_begin_nospec
      x86, get_user: use pointer masking to limit speculation
      x86: narrow out of bounds syscalls to sys_read under speculation
      vfs, fdtable: prevent bounds-check bypass via speculative execution
      kvm, x86: fix spectre-v1 mitigation
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
 arch/x86/kvm/vmx.c                |   19 ++---
 arch/x86/lib/getuser.S            |    5 +
 arch/x86/lib/usercopy_32.c        |    8 +-
 include/linux/fdtable.h           |    7 +-
 include/linux/nospec.h            |   65 +++++++++++++++++
 net/wireless/nl80211.c            |   10 ++-
 14 files changed, 312 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/speculation.txt
 create mode 100644 include/linux/nospec.h
