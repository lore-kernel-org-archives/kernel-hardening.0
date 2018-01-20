From: "Williams, Dan J" <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 18:36:41 +0000
Message-ID: <1516473386.30886.35.camel@intel.com>
Content-Type: text/plain; charset="utf-7"
Content-ID: <9C6FF396BDBA00418F0FA3F23647DE6C@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] [GIT PULL] spectre variant1 mitigations for 4.16
To: "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "alan@linux.intel.com" <alan@linux.intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Reshetova, Elena" <elena.reshetova@intel.com>, "johannes@sipsolutions.net" <johannes@sipsolutions.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "luto@kernel.org" <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Thomas, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec-v4.1

...to receive a collection of spectre-v1 mitigations, and
infrastructure for future mitigations.

The infrastructure includes:

+ACo- +AF8AXw-uaccess+AF8-begin+AF8-nospec: similar to +AF8AXw-uaccess+AF8-=
begin this invokes
'stac', but it also includes an 'ifence'. After an 'access+AF8-ok' check
has speculatively succeeded that result needs to be retired before the
user pointer is de-referenced. '+AF8AXw-get+AF8-user' can't use the pointer
sanitization approach without redoing the 'access+AF8-ok' check, so per
Linus +AFs-1+AF0- just use 'ifence'.

+ACo- MASK+AF8-NOSPEC: an assembler macro for x86 'get+AF8-user' and syscal=
l entry
that sanitizes a user controlled pointer or array index to zero after a
'cmp +ACU-limit +ACU-val' instruction sets the CF flag.

+ACo- array+AF8-ptr: When dereferencing a kernel pointer with a user contro=
lled
index, sanitize the pointer to either NULL or valid addresses under
speculation to eliminate a precondition for Spectre variant1 attacks.
It uses a mask generation technique that does not involve speculative
control flows on either x86 or ARM64 +AFs-2+AF0-.

+ACo- x86 array+AF8-ptr+AF8-mask: Achieve the same effect as the default
'array+AF8-ptr+AF8-mask' in fewer instructions. This approach does not have=
 the
same +ACI-array index and limit must be less than LONG+AF8-MAX+ACI- constra=
int as
the default mask.

+ACo- array+AF8-idx: Similar to 'array+AF8-ptr', use a mask to return a val=
id
pointer or NULL to an array index variable. An example where we need
this is the wireless driver stack where the core sanitizes user input
and the actual usage of the array index is in a different compilation
unit in the low-level driver.

The full patch is included below, this has received a build success
notification from the kbuild robot, survives a boot test, and I have
spot checked the generated assembly.

+AFs-1+AF0-: https://lkml.org/lkml/2018/1/17/929
+AFs-2+AF0-: https://www.spinics.net/lists/netdev/msg477542.html

The following changes since commit a8750ddca918032d6349adbf9a4b6555e7db20da=
:

  Linux 4.15-rc8 (2018-01-14 15:32:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec-v4.1

for you to fetch changes up to 4265eaab5a77015b476785a6e1ce9432398341bc:

  nl80211: sanitize array index in parse+AF8-txq+AF8-params (2018-01-19 22:=
46:57 -0800)

----------------------------------------------------------------
Dan Williams (9):
      asm/nospec, array+AF8-ptr: sanitize speculative array de-references
      x86: implement array+AF8-ptr+AF8-mask()
      x86: introduce +AF8AXw-uaccess+AF8-begin+AF8-nospec and ifence
      x86, +AF8AXw-get+AF8-user: use +AF8AXw-uaccess+AF8-begin+AF8-nospec
      x86, get+AF8-user: use pointer masking to limit speculation
      x86: narrow out of bounds syscalls to sys+AF8-read under speculation
      vfs, fdtable: prevent bounds-check bypass via speculative execution
      kvm, x86: update spectre-v1 mitigation
      nl80211: sanitize array index in parse+AF8-txq+AF8-params

Mark Rutland (1):
      Documentation: document array+AF8-ptr

 Documentation/speculation.txt     +AHw- 143 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 arch/x86/entry/entry+AF8-64.S         +AHw-   2 +-
 arch/x86/include/asm/barrier.h    +AHw-  28 +-+-+-+-+-+-+-+-
 arch/x86/include/asm/msr.h        +AHw-   3 +--
 arch/x86/include/asm/smap.h       +AHw-  24 +-+-+-+-+-+-+-
 arch/x86/include/asm/uaccess.h    +AHw-  15 +-+-+--
 arch/x86/include/asm/uaccess+AF8-32.h +AHw-   6 +--
 arch/x86/include/asm/uaccess+AF8-64.h +AHw-  12 +-+---
 arch/x86/kvm/vmx.c                +AHw-  19 +-+----
 arch/x86/lib/getuser.S            +AHw-   5 +-+-
 arch/x86/lib/usercopy+AF8-32.c        +AHw-   8 +---
 include/linux/fdtable.h           +AHw-   7 +--
 include/linux/nospec.h            +AHw-  65 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-=
+-+-
 net/wireless/nl80211.c            +AHw-  10 +-+--
 14 files changed, 312 insertions(+-), 35 deletions(-)
 create mode 100644 Documentation/speculation.txt
 create mode 100644 include/linux/nospec.h

commit 28789ca0d2e7fe100edfa74bd41dc9023d0e4a09
Author: Mark Rutland +ADw-mark.rutland+AEA-arm.com+AD4-
Date:   Wed Jan 3 19:47:06 2018 +-0000

    Documentation: document array+AF8-ptr
   =20
    Document the rationale and usage of the new array+AF8-ptr() helper.
   =20
    Signed-off-by: Mark Rutland +ADw-mark.rutland+AEA-arm.com+AD4-
    Signed-off-by: Will Deacon +ADw-will.deacon+AEA-arm.com+AD4-
    Cc: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
    Cc: Jonathan Corbet +ADw-corbet+AEA-lwn.net+AD4-
    Cc: Peter Zijlstra +ADw-peterz+AEA-infradead.org+AD4-
    Reviewed-by: Kees Cook +ADw-keescook+AEA-chromium.org+AD4-
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit f18e430135bc0fed13859a3cfa5c30bac18713b0
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Mon Jan 8 14:57:34 2018 -0800

    asm/nospec, array+AF8-ptr: sanitize speculative array de-references
   =20
    'array+AF8-ptr' is proposed as a generic mechanism to mitigate against
    Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
    via speculative execution). The 'array+AF8-ptr' implementation is expec=
ted
    to be safe for current generation cpus across multiple architectures
    (ARM, x86).
   =20
    Based on an original implementation by Linus Torvalds, tweaked to remov=
e
    speculative flows by Alexei Starovoitov, and tweaked again by Linus to
    introduce an x86 assembly implementation for the mask generation.
   =20
    Co-developed-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+=
AD4-
    Co-developed-by: Alexei Starovoitov +ADw-ast+AEA-kernel.org+AD4-
    Cc: Peter Zijlstra +ADw-peterz+AEA-infradead.org+AD4-
    Cc: Russell King +ADw-linux+AEA-armlinux.org.uk+AD4-
    Cc: Catalin Marinas +ADw-catalin.marinas+AEA-arm.com+AD4-
    Cc: Will Deacon +ADw-will.deacon+AEA-arm.com+AD4-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: x86+AEA-kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 9c79e30dff10ac172fa8bb824d1fef963500c2b5
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Tue Jan 9 13:19:55 2018 -0800

    x86: implement array+AF8-ptr+AF8-mask()
   =20
    'array+AF8-ptr' uses a mask to sanitize user controllable pointers.  Th=
e x86
    'array+AF8-ptr+AF8-mask' is an assembler optimized way to generate a 0 =
or +AH4-0
    mask if an array index is out-of-bounds or in-bounds.
   =20
    Suggested-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+AD4=
-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: x86+AEA-kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 7afd0bf63320d156168c484f428d172918bb515c
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Wed Jan 17 11:22:55 2018 -0800

    x86: introduce +AF8AXw-uaccess+AF8-begin+AF8-nospec and ifence
   =20
    For '+AF8AXw-get+AF8-user' paths, do not allow the kernel to speculate =
on the
    value of a user controlled pointer. In addition to the 'stac'
    instruction for Supervisor Mode Access Protection, an 'ifence' causes
    the 'access+AF8-ok' result to resolve in the pipeline before the cpu mi=
ght
    take any speculative action on the pointer value.
   =20
    Since +AF8AXw-get+AF8-user is a major kernel interface that deals with =
user
    controlled pointers, the '+AF8AXw-uaccess+AF8-begin+AF8-nospec' mechani=
sm will prevent
    speculative execution past an 'access+AF8-ok' permission check. While
    speculative execution past 'access+AF8-ok' is not enough to lead to a k=
ernel
    memory leak, it is a necessary precondition.
   =20
    To be clear, '+AF8AXw-uaccess+AF8-begin+AF8-nospec' is addressing a cla=
ss of potential
    problems near '+AF8AXw-get+AF8-user' usages.
   =20
    Note, that while ifence is used to protect '+AF8AXw-get+AF8-user', poin=
ter masking
    will be used for 'get+AF8-user' since it incorporates a bounds check ne=
ar
    the usage.
   =20
    There are no functional changes in this patch.
   =20
    Suggested-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+AD4=
-
    Suggested-by: Andi Kleen +ADw-ak+AEA-linux.intel.com+AD4-
    Cc: Tom Lendacky +ADw-thomas.lendacky+AEA-amd.com+AD4-
    Cc: Al Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
    Cc: Kees Cook +ADw-keescook+AEA-chromium.org+AD4-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: x86+AEA-kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit bad6716b8bd73e5415052a9f06ff607780655e93
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Fri Jan 12 15:49:30 2018 -0800

    x86, +AF8AXw-get+AF8-user: use +AF8AXw-uaccess+AF8-begin+AF8-nospec
   =20
    Quoting Linus:
   =20
        I do think that it would be a good idea to very expressly document
        the fact that it's not that the user access itself is unsafe. I do
        agree that things like +ACI-get+AF8-user()+ACI- want to be protecte=
d, but not
        because of any direct bugs or problems with get+AF8-user() and frie=
nds,
        but simply because get+AF8-user() is an excellent source of a point=
er
        that is obviously controlled from a potentially attacking user
        space. So it's a prime candidate for then finding +AF8-subsequent+A=
F8-
        accesses that can then be used to perturb the cache.
   =20
    '+AF8AXw-uaccess+AF8-begin+AF8-nospec' covers '+AF8AXw-get+AF8-user' an=
d 'copy+AF8-from+AF8-iter' where
    the limit check is far away from the user pointer de-reference. In thos=
e
    cases an 'lfence' prevents speculation with a potential pointer to
    privileged memory.
   =20
    Suggested-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+AD4=
-
    Suggested-by: Andi Kleen +ADw-ak+AEA-linux.intel.com+AD4-
    Cc: Al Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
    Cc: Kees Cook +ADw-keescook+AEA-chromium.org+AD4-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: x86+AEA-kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 582db732ea168afb92205ca3c81b253324c3453b
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Tue Jan 16 17:24:35 2018 -0800

    x86, get+AF8-user: use pointer masking to limit speculation
   =20
    Quoting Linus:
   =20
        I do think that it would be a good idea to very expressly document
        the fact that it's not that the user access itself is unsafe. I do
        agree that things like +ACI-get+AF8-user()+ACI- want to be protecte=
d, but not
        because of any direct bugs or problems with get+AF8-user() and frie=
nds,
        but simply because get+AF8-user() is an excellent source of a point=
er
        that is obviously controlled from a potentially attacking user
        space. So it's a prime candidate for then finding +AF8-subsequent+A=
F8-
        accesses that can then be used to perturb the cache.
   =20
    Unlike the '+AF8AXw-get+AF8-user' case 'get+AF8-user' includes the addr=
ess limit check
    near the pointer de-reference. With that locality the speculation can b=
e
    mitigated with pointer narrowing rather than a barrier. Where the
    narrowing is performed by:
   =20
            cmp +ACU-limit, +ACU-ptr
            sbb +ACU-mask, +ACU-mask
            and +ACU-mask, +ACU-ptr
   =20
    With respect to speculation the value of +ACU-ptr is either less than +=
ACU-limit
    or NULL.
   =20
    Co-developed-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+=
AD4-
    Cc: Al Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
    Cc: Kees Cook +ADw-keescook+AEA-chromium.org+AD4-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: x86+AEA-kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit b6f816a66a6780073ad6b26321dc9a68ee513eb7
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Thu Jan 18 10:45:00 2018 -0800

    x86: narrow out of bounds syscalls to sys+AF8-read under speculation
   =20
    The syscall table base is a user controlled function pointer in kernel
    space. Like, 'get+AF8-user, use 'MASK+AF8-NOSPEC' to prevent any out of=
 bounds
    speculation. While retpoline prevents speculating into the user
    controlled target it does not stop the pointer de-reference, the concer=
n
    is leaking memory relative to the syscall table base.
   =20
    Reported-by: Linus Torvalds +ADw-torvalds+AEA-linux-foundation.org+AD4-
    Cc: Thomas Gleixner +ADw-tglx+AEA-linutronix.de+AD4-
    Cc: Ingo Molnar +ADw-mingo+AEA-redhat.com+AD4-
    Cc: +ACI-H. Peter Anvin+ACI- +ADw-hpa+AEA-zytor.com+AD4-
    Cc: x86+AEA-kernel.org
    Cc: Andy Lutomirski +ADw-luto+AEA-kernel.org+AD4-
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 815436a2b32e3f9f9c7a3de78a96936b2f45def9
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Wed Jan 3 13:54:04 2018 -0800

    vfs, fdtable: prevent bounds-check bypass via speculative execution
   =20
    'fd' is a user controlled value that is used as a data dependency to
    read from the 'fdt-+AD4-fd' array.  In order to avoid potential leaks o=
f
    kernel memory values, block speculative execution of the instruction
    stream that could issue reads based on an invalid 'file +ACo-' returned=
 from
    +AF8AXw-fcheck+AF8-files.
   =20
    Cc: Al Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
    Co-developed-by: Elena Reshetova +ADw-elena.reshetova+AEA-intel.com+AD4=
-
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 826d3c8921357397c906874565e21f4b1a24afdf
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Wed Jan 17 13:29:40 2018 -0800

    kvm, x86: update spectre-v1 mitigation
   =20
    Commit 75f139aaf896 +ACI-KVM: x86: Add memory barrier on vmcs field loo=
kup+ACI-
    added a raw 'asm(+ACI-lfence+ACI-)+ADs-' to prevent a bounds check bypa=
ss of
    'vmcs+AF8-field+AF8-to+AF8-offset+AF8-table'. We can save an lfence in =
this path and
    just use the common 'array+AF8-ptr' helper designed for these types of
    fixes.
   =20
    Cc: Andrew Honig +ADw-ahonig+AEA-google.com+AD4-
    Cc: Jim Mattson +ADw-jmattson+AEA-google.com+AD4-
    Acked-by: Paolo Bonzini +ADw-pbonzini+AEA-redhat.com+AD4-
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 4265eaab5a77015b476785a6e1ce9432398341bc
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:   Wed Jan 17 16:01:37 2018 -0800

    nl80211: sanitize array index in parse+AF8-txq+AF8-params
   =20
    Wireless drivers rely on parse+AF8-txq+AF8-params to validate that
    txq+AF8-params-+AD4-ac is less than NL80211+AF8-NUM+AF8-ACS by the time=
 the low-level
    driver's -+AD4-conf+AF8-tx() handler is called. Use a new helper, 'arra=
y+AF8-idx',
    to sanitize txq+AF8-params-+AD4-ac with respect to speculation. I.e. en=
sure that
    any speculation into -+AD4-conf+AF8-tx() handlers is done with a value =
of
    txq+AF8-params-+AD4-ac that is within the bounds of +AFs-0, NL80211+AF8=
-NUM+AF8-ACS).
   =20
    Reported-by: Christian Lamparter +ADw-chunkeey+AEA-gmail.com+AD4-
    Reported-by: Elena Reshetova +ADw-elena.reshetova+AEA-intel.com+AD4-
    Cc: Johannes Berg +ADw-johannes+AEA-sipsolutions.net+AD4-
    Cc: +ACI-David S. Miller+ACI- +ADw-davem+AEA-davemloft.net+AD4-
    Cc: linux-wireless+AEA-vger.kernel.org
    Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

diff --git a/Documentation/speculation.txt b/Documentation/speculation.txt
new file mode 100644
index 000000000000..a47fbffe0dab
--- /dev/null
+-+-+- b/Documentation/speculation.txt
+AEAAQA- -0,0 +-1,143 +AEAAQA-
+-This document explains potential effects of speculation, and how undesira=
ble
+-effects can be mitigated portably using common APIs.
+-
+-+AD0APQA9AD0APQA9AD0APQA9AD0APQ-
+-Speculation
+-+AD0APQA9AD0APQA9AD0APQA9AD0APQ-
+-
+-To improve performance and minimize average latencies, many contemporary =
CPUs
+-employ speculative execution techniques such as branch prediction, perfor=
ming
+-work which may be discarded at a later stage.
+-
+-Typically speculative execution cannot be observed from architectural sta=
te,
+-such as the contents of registers. However, in some cases it is possible =
to
+-observe its impact on microarchitectural state, such as the presence or
+-absence of data in caches. Such state may form side-channels which can be
+-observed to extract secret information.
+-
+-For example, in the presence of branch prediction, it is possible for bou=
nds
+-checks to be ignored by code which is speculatively executed. Consider th=
e
+-following code:
+-
+-	int load+AF8-array(int +ACo-array, unsigned int idx)
+-	+AHs-
+-		if (idx +AD4APQ- MAX+AF8-ARRAY+AF8-ELEMS)
+-			return 0+ADs-
+-		else
+-			return array+AFs-idx+AF0AOw-
+-	+AH0-
+-
+-Which, on arm64, may be compiled to an assembly sequence such as:
+-
+-	CMP	+ADw-idx+AD4-, +ACM-MAX+AF8-ARRAY+AF8-ELEMS
+-	B.LT	less
+-	MOV	+ADw-returnval+AD4-, +ACM-0
+-	RET
+-  less:
+-	LDR	+ADw-returnval+AD4-, +AFsAPA-array+AD4-, +ADw-idx+AD4AXQ-
+-	RET
+-
+-It is possible that a CPU mis-predicts the conditional branch, and
+-speculatively loads array+AFs-idx+AF0-, even if idx +AD4APQ- MAX+AF8-ARRA=
Y+AF8-ELEMS. This value
+-will subsequently be discarded, but the speculated load may affect
+-microarchitectural state which can be subsequently measured.
+-
+-More complex sequences involving multiple dependent memory accesses may r=
esult
+-in sensitive information being leaked. Consider the following code, build=
ing
+-on the prior example:
+-
+-	int load+AF8-dependent+AF8-arrays(int +ACo-arr1, int +ACo-arr2, int idx)
+-	+AHs-
+-		int val1, val2,
+-
+-		val1 +AD0- load+AF8-array(arr1, idx)+ADs-
+-		val2 +AD0- load+AF8-array(arr2, val1)+ADs-
+-
+-		return val2+ADs-
+-	+AH0-
+-
+-Under speculation, the first call to load+AF8-array() may return the valu=
e of an
+-out-of-bounds address, while the second call will influence microarchitec=
tural
+-state dependent on this value. This may provide an arbitrary read primiti=
ve.
+-
+-+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9=
AD0APQA9AD0APQA9AD0APQA9-
+-Mitigating speculation side-channels
+-+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9=
AD0APQA9AD0APQA9AD0APQA9-
+-
+-The kernel provides a generic API to ensure that bounds checks are respec=
ted
+-even under speculation. Architectures which are affected by speculation-b=
ased
+-side-channels are expected to implement these primitives.
+-
+-The array+AF8-ptr() helper in +ADw-asm/barrier.h+AD4- can be used to prev=
ent
+-information from being leaked via side-channels.
+-
+-A call to array+AF8-ptr(arr, idx, sz) returns a sanitized pointer to
+-arr+AFs-idx+AF0- only if idx falls in the +AFs-0, sz) interval. When idx =
+ADw- 0 or idx +AD4- sz,
+-NULL is returned. Additionally, array+AF8-ptr() of an out-of-bounds point=
er is
+-not propagated to code which is speculatively executed.
+-
+-This can be used to protect the earlier load+AF8-array() example:
+-
+-	int load+AF8-array(int +ACo-array, unsigned int idx)
+-	+AHs-
+-		int +ACo-elem+ADs-
+-
+-		elem +AD0- array+AF8-ptr(array, idx, MAX+AF8-ARRAY+AF8-ELEMS)+ADs-
+-		if (elem)
+-			return +ACo-elem+ADs-
+-		else
+-			return 0+ADs-
+-	+AH0-
+-
+-This can also be used in situations where multiple fields on a structure =
are
+-accessed:
+-
+-	struct foo array+AFs-SIZE+AF0AOw-
+-	int a, b+ADs-
+-
+-	void do+AF8-thing(int idx)
+-	+AHs-
+-		struct foo +ACo-elem+ADs-
+-
+-		elem +AD0- array+AF8-ptr(array, idx, SIZE)+ADs-
+-		if (elem) +AHs-
+-			a +AD0- elem-+AD4-field+AF8-a+ADs-
+-			b +AD0- elem-+AD4-field+AF8-b+ADs-
+-		+AH0-
+-	+AH0-
+-
+-It is imperative that the returned pointer is used. Pointers which are
+-generated separately are subject to a number of potential CPU and compile=
r
+-optimizations, and may still be used speculatively. For example, this mea=
ns
+-that the following sequence is unsafe:
+-
+-	struct foo array+AFs-SIZE+AF0AOw-
+-	int a, b+ADs-
+-
+-	void do+AF8-thing(int idx)
+-	+AHs-
+-		if (array+AF8-ptr(array, idx, SIZE) +ACEAPQ- NULL) +AHs-
+-			// unsafe as wrong pointer is used
+-			a +AD0- array+AFs-idx+AF0-.field+AF8-a+ADs-
+-			b +AD0- array+AFs-idx+AF0-.field+AF8-b+ADs-
+-		+AH0-
+-	+AH0-
+-
+-Similarly, it is unsafe to compare the returned pointer with other pointe=
rs,
+-as this may permit the compiler to substitute one pointer with another,
+-permitting speculation. For example, the following sequence is unsafe:
+-
+-	struct foo array+AFs-SIZE+AF0AOw-
+-	int a, b+ADs-
+-
+-	void do+AF8-thing(int idx)
+-	+AHs-
+-		struct foo +ACo-elem +AD0- array+AF8-ptr(array, idx, size)+ADs-
+-
+-		// unsafe due to pointer substitution
+-		if (elem +AD0APQ- +ACY-array+AFs-idx+AF0-) +AHs-
+-			a +AD0- elem-+AD4-field+AF8-a+ADs-
+-			b +AD0- elem-+AD4-field+AF8-b+ADs-
+-		+AH0-
+-	+AH0-
+-
diff --git a/arch/x86/entry/entry+AF8-64.S b/arch/x86/entry/entry+AF8-64.S
index 4f8e1d35a97c..2320017077d4 100644
--- a/arch/x86/entry/entry+AF8-64.S
+-+-+- b/arch/x86/entry/entry+AF8-64.S
+AEAAQA- -35,6 +-35,7 +AEAAQA-
 +ACM-include +ADw-asm/asm.h+AD4-
 +ACM-include +ADw-asm/smap.h+AD4-
 +ACM-include +ADw-asm/pgtable+AF8-types.h+AD4-
+-+ACM-include +ADw-asm/smap.h+AD4-
 +ACM-include +ADw-asm/export.h+AD4-
 +ACM-include +ADw-asm/frame.h+AD4-
 +ACM-include +ADw-asm/nospec-branch.h+AD4-
+AEAAQA- -264,6 +-265,7 +AEAAQA- entry+AF8-SYSCALL+AF8-64+AF8-fastpath:
 	cmpl	+ACQAXwBf-NR+AF8-syscall+AF8-max, +ACU-eax
 +ACM-endif
 	ja	1f				/+ACo- return -ENOSYS (already in pt+AF8-regs-+AD4-ax) +ACo-/
+-	MASK+AF8-NOSPEC +ACU-r11 +ACU-rax			/+ACo- sanitize syscall+AF8-nr wrt s=
peculation +ACo-/
 	movq	+ACU-r10, +ACU-rcx
=20
 	/+ACo-
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.=
h
index 7fb336210e1b..0f48c832d1fb 100644
--- a/arch/x86/include/asm/barrier.h
+-+-+- b/arch/x86/include/asm/barrier.h
+AEAAQA- -24,6 +-24,34 +AEAAQA-
 +ACM-define wmb()	asm volatile(+ACI-sfence+ACI- ::: +ACI-memory+ACI-)
 +ACM-endif
=20
+-/+ACoAKg-
+- +ACo- array+AF8-ptr+AF8-mask - generate a mask for array+AF8-ptr() that =
is +AH4-0UL when
+- +ACo- the bounds check succeeds and 0 otherwise
+- +ACo-/
+-+ACM-define array+AF8-ptr+AF8-mask array+AF8-ptr+AF8-mask
+-static inline unsigned long array+AF8-ptr+AF8-mask(unsigned long idx, uns=
igned long sz)
+-+AHs-
+-	unsigned long mask+ADs-
+-
+-	/+ACo-
+-	 +ACo- mask +AD0- index - size, if that result is +AD4APQ- 0 then the in=
dex is
+-	 +ACo- invalid and the mask is 0 else +AH4-0
+-	 +ACo-/
+-+ACM-ifdef CONFIG+AF8-X86+AF8-32
+-	asm (+ACI-cmpl +ACU-1,+ACU-2+ADs- sbbl +ACU-0,+ACU-0+ADsAIg-
+-+ACM-else
+-	asm (+ACI-cmpq +ACU-1,+ACU-2+ADs- sbbq +ACU-0,+ACU-0+ADsAIg-
+-+ACM-endif
+-			:+ACIAPQ-r+ACI- (mask)
+-			:+ACI-r+ACI-(sz),+ACI-r+ACI- (idx)
+-			:+ACI-cc+ACI-)+ADs-
+-	return mask+ADs-
+-+AH0-
+-
+-/+ACo- prevent speculative execution past this barrier +ACo-/
+-+ACM-define ifence() alternative+AF8-2(+ACIAIg-, +ACI-mfence+ACI-, X86+AF=
8-FEATURE+AF8-MFENCE+AF8-RDTSC, +AFw-
+-				   +ACI-lfence+ACI-, X86+AF8-FEATURE+AF8-LFENCE+AF8-RDTSC)
+-
 +ACM-ifdef CONFIG+AF8-X86+AF8-PPRO+AF8-FENCE
 +ACM-define dma+AF8-rmb()	rmb()
 +ACM-else
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 07962f5f6fba..e426d2a33ff3 100644
--- a/arch/x86/include/asm/msr.h
+-+-+- b/arch/x86/include/asm/msr.h
+AEAAQA- -214,8 +-214,7 +AEAAQA- static +AF8AXw-always+AF8-inline unsigned =
long long rdtsc+AF8-ordered(void)
 	 +ACo- that some other imaginary CPU is updating continuously with a
 	 +ACo- time stamp.
 	 +ACo-/
-	alternative+AF8-2(+ACIAIg-, +ACI-mfence+ACI-, X86+AF8-FEATURE+AF8-MFENCE+=
AF8-RDTSC,
-			  +ACI-lfence+ACI-, X86+AF8-FEATURE+AF8-LFENCE+AF8-RDTSC)+ADs-
+-	ifence()+ADs-
 	return rdtsc()+ADs-
 +AH0-
=20
diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index db333300bd4b..3b5b2cf58dc6 100644
--- a/arch/x86/include/asm/smap.h
+-+-+- b/arch/x86/include/asm/smap.h
+AEAAQA- -25,6 +-25,30 +AEAAQA-
=20
 +ACM-include +ADw-asm/alternative-asm.h+AD4-
=20
+-/+ACo-
+- +ACo- MASK+AF8-NOSPEC - sanitize the value of a user controlled value wi=
th
+- +ACo- respect to speculation
+- +ACo-
+- +ACo- In the get+AF8-user path once we have determined that the pointer =
is
+- +ACo- below the current address limit sanitize its value with respect to
+- +ACo- speculation. In the case when the pointer is above the address lim=
it
+- +ACo- this directs the cpu to speculate with a NULL ptr rather than
+- +ACo- something targeting kernel memory.
+- +ACo-
+- +ACo- In the syscall entry path it is possible to speculate past the
+- +ACo- validation of the system call number. Use MASK+AF8-NOSPEC to sanit=
ize the
+- +ACo- syscall array index to zero (sys+AF8-read) rather than an arbitrar=
y
+- +ACo- target.
+- +ACo-
+- +ACo- assumes CF is set from a previous 'cmp' i.e.:
+- +ACo-     cmp TASK+AF8-addr+AF8-limit, +ACU-ptr
+- +ACo-     cmp +AF8AXw-NR+AF8-syscall+AF8-max, +ACU-idx
+- +ACo-/
+-.macro MASK+AF8-NOSPEC mask val
+-	sbb +AFw-mask, +AFw-mask
+-	and +AFw-mask, +AFw-val
+-.endm
+-
 +ACM-ifdef CONFIG+AF8-X86+AF8-SMAP
=20
 +ACM-define ASM+AF8-CLAC +AFw-
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.=
h
index 574dff4d2913..a930585fa3b5 100644
--- a/arch/x86/include/asm/uaccess.h
+-+-+- b/arch/x86/include/asm/uaccess.h
+AEAAQA- -124,6 +-124,11 +AEAAQA- extern int +AF8AXw-get+AF8-user+AF8-bad(v=
oid)+ADs-
=20
 +ACM-define +AF8AXw-uaccess+AF8-begin() stac()
 +ACM-define +AF8AXw-uaccess+AF8-end()   clac()
+-+ACM-define +AF8AXw-uaccess+AF8-begin+AF8-nospec()	+AFw-
+-(+AHs-					+AFw-
+-	stac()+ADs-				+AFw-
+-	ifence()+ADs-			+AFw-
+-+AH0-)
=20
 /+ACo-
  +ACo- This is a type: either unsigned long, if the argument fits into
+AEAAQA- -445,7 +-450,7 +AEAAQA- do +AHs-									+AFw-
 (+AHs-									+AFw-
 	int +AF8AXw-gu+AF8-err+ADs-							+AFw-
 	+AF8AXw-inttype(+ACo-(ptr)) +AF8AXw-gu+AF8-val+ADs-					+AFw-
-	+AF8AXw-uaccess+AF8-begin()+ADs-						+AFw-
+-	+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-					+AFw-
 	+AF8AXw-get+AF8-user+AF8-size(+AF8AXw-gu+AF8-val, (ptr), (size), +AF8AXw-=
gu+AF8-err, -EFAULT)+ADs-	+AFw-
 	+AF8AXw-uaccess+AF8-end()+ADs-						+AFw-
 	(x) +AD0- (+AF8AXw-force +AF8AXw-typeof+AF8AXw-(+ACo-(ptr)))+AF8AXw-gu+AF=
8-val+ADs-			+AFw-
+AEAAQA- -487,6 +-492,10 +AEAAQA- struct +AF8AXw-large+AF8-struct +AHs- uns=
igned long buf+AFs-100+AF0AOw- +AH0AOw-
 	+AF8AXw-uaccess+AF8-begin()+ADs-						+AFw-
 	barrier()+ADs-
=20
+-+ACM-define uaccess+AF8-try+AF8-nospec do +AHs-						+AFw-
+-	current-+AD4-thread.uaccess+AF8-err +AD0- 0+ADs-				+AFw-
+-	+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-					+AFw-
+-
 +ACM-define uaccess+AF8-catch(err)						+AFw-
 	+AF8AXw-uaccess+AF8-end()+ADs-						+AFw-
 	(err) +AHwAPQ- (current-+AD4-thread.uaccess+AF8-err ? -EFAULT : 0)+ADs-		=
+AFw-
+AEAAQA- -548,7 +-557,7 +AEAAQA- struct +AF8AXw-large+AF8-struct +AHs- unsi=
gned long buf+AFs-100+AF0AOw- +AH0AOw-
  +ACo-	get+AF8-user+AF8-ex(...)+ADs-
  +ACo- +AH0- get+AF8-user+AF8-catch(err)
  +ACo-/
-+ACM-define get+AF8-user+AF8-try		uaccess+AF8-try
+-+ACM-define get+AF8-user+AF8-try		uaccess+AF8-try+AF8-nospec
 +ACM-define get+AF8-user+AF8-catch(err)	uaccess+AF8-catch(err)
=20
 +ACM-define get+AF8-user+AF8-ex(x, ptr)	do +AHs-					+AFw-
+AEAAQA- -582,7 +-591,7 +AEAAQA- extern void +AF8AXw-cmpxchg+AF8-wrong+AF8-=
size(void)
 	+AF8AXw-typeof+AF8AXw-(ptr) +AF8AXw-uval +AD0- (uval)+ADs-				+AFw-
 	+AF8AXw-typeof+AF8AXw-(+ACo-(ptr)) +AF8AXw-old +AD0- (old)+ADs-				+AFw-
 	+AF8AXw-typeof+AF8AXw-(+ACo-(ptr)) +AF8AXw-new +AD0- (new)+ADs-				+AFw-
-	+AF8AXw-uaccess+AF8-begin()+ADs-						+AFw-
+-	+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-					+AFw-
 	switch (size) +AHs-							+AFw-
 	case 1:								+AFw-
 	+AHs-								+AFw-
diff --git a/arch/x86/include/asm/uaccess+AF8-32.h b/arch/x86/include/asm/u=
access+AF8-32.h
index 72950401b223..ba2dc1930630 100644
--- a/arch/x86/include/asm/uaccess+AF8-32.h
+-+-+- b/arch/x86/include/asm/uaccess+AF8-32.h
+AEAAQA- -29,21 +-29,21 +AEAAQA- raw+AF8-copy+AF8-from+AF8-user(void +ACo-t=
o, const void +AF8AXw-user +ACo-from, unsigned long n)
 		switch (n) +AHs-
 		case 1:
 			ret +AD0- 0+ADs-
-			+AF8AXw-uaccess+AF8-begin()+ADs-
+-			+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 			+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u8 +ACo-)to, from, ret,
 					      +ACI-b+ACI-, +ACI-b+ACI-, +ACIAPQ-q+ACI-, 1)+ADs-
 			+AF8AXw-uaccess+AF8-end()+ADs-
 			return ret+ADs-
 		case 2:
 			ret +AD0- 0+ADs-
-			+AF8AXw-uaccess+AF8-begin()+ADs-
+-			+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 			+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u16 +ACo-)to, from, ret,
 					      +ACI-w+ACI-, +ACI-w+ACI-, +ACIAPQ-r+ACI-, 2)+ADs-
 			+AF8AXw-uaccess+AF8-end()+ADs-
 			return ret+ADs-
 		case 4:
 			ret +AD0- 0+ADs-
-			+AF8AXw-uaccess+AF8-begin()+ADs-
+-			+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 			+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u32 +ACo-)to, from, ret,
 					      +ACI-l+ACI-, +ACI-k+ACI-, +ACIAPQ-r+ACI-, 4)+ADs-
 			+AF8AXw-uaccess+AF8-end()+ADs-
diff --git a/arch/x86/include/asm/uaccess+AF8-64.h b/arch/x86/include/asm/u=
access+AF8-64.h
index f07ef3c575db..62546b3a398e 100644
--- a/arch/x86/include/asm/uaccess+AF8-64.h
+-+-+- b/arch/x86/include/asm/uaccess+AF8-64.h
+AEAAQA- -55,31 +-55,31 +AEAAQA- raw+AF8-copy+AF8-from+AF8-user(void +ACo-d=
st, const void +AF8AXw-user +ACo-src, unsigned long size)
 		return copy+AF8-user+AF8-generic(dst, (+AF8AXw-force void +ACo-)src, siz=
e)+ADs-
 	switch (size) +AHs-
 	case 1:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u8 +ACo-)dst, (u8 +AF8AXw-=
user +ACo-)src,
 			      ret, +ACI-b+ACI-, +ACI-b+ACI-, +ACIAPQ-q+ACI-, 1)+ADs-
 		+AF8AXw-uaccess+AF8-end()+ADs-
 		return ret+ADs-
 	case 2:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u16 +ACo-)dst, (u16 +AF8AX=
w-user +ACo-)src,
 			      ret, +ACI-w+ACI-, +ACI-w+ACI-, +ACIAPQ-r+ACI-, 2)+ADs-
 		+AF8AXw-uaccess+AF8-end()+ADs-
 		return ret+ADs-
 	case 4:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u32 +ACo-)dst, (u32 +AF8AX=
w-user +ACo-)src,
 			      ret, +ACI-l+ACI-, +ACI-k+ACI-, +ACIAPQ-r+ACI-, 4)+ADs-
 		+AF8AXw-uaccess+AF8-end()+ADs-
 		return ret+ADs-
 	case 8:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u64 +ACo-)dst, (u64 +AF8AX=
w-user +ACo-)src,
 			      ret, +ACI-q+ACI-, +ACIAIg-, +ACIAPQ-r+ACI-, 8)+ADs-
 		+AF8AXw-uaccess+AF8-end()+ADs-
 		return ret+ADs-
 	case 10:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u64 +ACo-)dst, (u64 +AF8AX=
w-user +ACo-)src,
 			       ret, +ACI-q+ACI-, +ACIAIg-, +ACIAPQ-r+ACI-, 10)+ADs-
 		if (likely(+ACE-ret))
+AEAAQA- -89,7 +-89,7 +AEAAQA- raw+AF8-copy+AF8-from+AF8-user(void +ACo-dst=
, const void +AF8AXw-user +ACo-src, unsigned long size)
 		+AF8AXw-uaccess+AF8-end()+ADs-
 		return ret+ADs-
 	case 16:
-		+AF8AXw-uaccess+AF8-begin()+ADs-
+-		+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 		+AF8AXw-get+AF8-user+AF8-asm+AF8-nozero(+ACo-(u64 +ACo-)dst, (u64 +AF8AX=
w-user +ACo-)src,
 			       ret, +ACI-q+ACI-, +ACIAIg-, +ACIAPQ-r+ACI-, 16)+ADs-
 		if (likely(+ACE-ret))
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c829d89e2e63..20b9b0b5e336 100644
--- a/arch/x86/kvm/vmx.c
+-+-+- b/arch/x86/kvm/vmx.c
+AEAAQA- -34,6 +-34,7 +AEAAQA-
 +ACM-include +ADw-linux/tboot.h+AD4-
 +ACM-include +ADw-linux/hrtimer.h+AD4-
 +ACM-include +ADw-linux/frame.h+AD4-
+-+ACM-include +ADw-linux/nospec.h+AD4-
 +ACM-include +ACI-kvm+AF8-cache+AF8-regs.h+ACI-
 +ACM-include +ACI-x86.h+ACI-
=20
+AEAAQA- -898,21 +-899,15 +AEAAQA- static const unsigned short vmcs+AF8-fie=
ld+AF8-to+AF8-offset+AF8-table+AFsAXQ- +AD0- +AHs-
=20
 static inline short vmcs+AF8-field+AF8-to+AF8-offset(unsigned long field)
 +AHs-
-	BUILD+AF8-BUG+AF8-ON(ARRAY+AF8-SIZE(vmcs+AF8-field+AF8-to+AF8-offset+AF8-=
table) +AD4- SHRT+AF8-MAX)+ADs-
-
-	if (field +AD4APQ- ARRAY+AF8-SIZE(vmcs+AF8-field+AF8-to+AF8-offset+AF8-ta=
ble))
-		return -ENOENT+ADs-
+-	const unsigned short +ACo-offset+ADs-
=20
-	/+ACo-
-	 +ACo- FIXME: Mitigation for CVE-2017-5753.  To be replaced with a
-	 +ACo- generic mechanism.
-	 +ACo-/
-	asm(+ACI-lfence+ACI-)+ADs-
+-	BUILD+AF8-BUG+AF8-ON(ARRAY+AF8-SIZE(vmcs+AF8-field+AF8-to+AF8-offset+AF8=
-table) +AD4- SHRT+AF8-MAX)+ADs-
=20
-	if (vmcs+AF8-field+AF8-to+AF8-offset+AF8-table+AFs-field+AF0- +AD0APQ- 0)
+-	offset +AD0- array+AF8-ptr(vmcs+AF8-field+AF8-to+AF8-offset+AF8-table, f=
ield,
+-			ARRAY+AF8-SIZE(vmcs+AF8-field+AF8-to+AF8-offset+AF8-table))+ADs-
+-	if (+ACE-offset +AHwAfA- +ACo-offset +AD0APQ- 0)
 		return -ENOENT+ADs-
-
-	return vmcs+AF8-field+AF8-to+AF8-offset+AF8-table+AFs-field+AF0AOw-
+-	return +ACo-offset+ADs-
 +AH0-
=20
 static inline struct vmcs12 +ACo-get+AF8-vmcs12(struct kvm+AF8-vcpu +ACo-v=
cpu)
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index c97d935a29e8..07d0e8a28b17 100644
--- a/arch/x86/lib/getuser.S
+-+-+- b/arch/x86/lib/getuser.S
+AEAAQA- -40,6 +-40,7 +AEAAQA- ENTRY(+AF8AXw-get+AF8-user+AF8-1)
 	mov PER+AF8-CPU+AF8-VAR(current+AF8-task), +ACUAXw-ASM+AF8-DX
 	cmp TASK+AF8-addr+AF8-limit(+ACUAXw-ASM+AF8-DX),+ACUAXw-ASM+AF8-AX
 	jae bad+AF8-get+AF8-user
+-	MASK+AF8-NOSPEC +ACUAXw-ASM+AF8-DX, +ACUAXw-ASM+AF8-AX
 	ASM+AF8-STAC
 1:	movzbl (+ACUAXw-ASM+AF8-AX),+ACU-edx
 	xor +ACU-eax,+ACU-eax
+AEAAQA- -54,6 +-55,7 +AEAAQA- ENTRY(+AF8AXw-get+AF8-user+AF8-2)
 	mov PER+AF8-CPU+AF8-VAR(current+AF8-task), +ACUAXw-ASM+AF8-DX
 	cmp TASK+AF8-addr+AF8-limit(+ACUAXw-ASM+AF8-DX),+ACUAXw-ASM+AF8-AX
 	jae bad+AF8-get+AF8-user
+-	MASK+AF8-NOSPEC +ACUAXw-ASM+AF8-DX, +ACUAXw-ASM+AF8-AX
 	ASM+AF8-STAC
 2:	movzwl -1(+ACUAXw-ASM+AF8-AX),+ACU-edx
 	xor +ACU-eax,+ACU-eax
+AEAAQA- -68,6 +-70,7 +AEAAQA- ENTRY(+AF8AXw-get+AF8-user+AF8-4)
 	mov PER+AF8-CPU+AF8-VAR(current+AF8-task), +ACUAXw-ASM+AF8-DX
 	cmp TASK+AF8-addr+AF8-limit(+ACUAXw-ASM+AF8-DX),+ACUAXw-ASM+AF8-AX
 	jae bad+AF8-get+AF8-user
+-	MASK+AF8-NOSPEC +ACUAXw-ASM+AF8-DX, +ACUAXw-ASM+AF8-AX
 	ASM+AF8-STAC
 3:	movl -3(+ACUAXw-ASM+AF8-AX),+ACU-edx
 	xor +ACU-eax,+ACU-eax
+AEAAQA- -83,6 +-86,7 +AEAAQA- ENTRY(+AF8AXw-get+AF8-user+AF8-8)
 	mov PER+AF8-CPU+AF8-VAR(current+AF8-task), +ACUAXw-ASM+AF8-DX
 	cmp TASK+AF8-addr+AF8-limit(+ACUAXw-ASM+AF8-DX),+ACUAXw-ASM+AF8-AX
 	jae bad+AF8-get+AF8-user
+-	MASK+AF8-NOSPEC +ACUAXw-ASM+AF8-DX, +ACUAXw-ASM+AF8-AX
 	ASM+AF8-STAC
 4:	movq -7(+ACUAXw-ASM+AF8-AX),+ACU-rdx
 	xor +ACU-eax,+ACU-eax
+AEAAQA- -94,6 +-98,7 +AEAAQA- ENTRY(+AF8AXw-get+AF8-user+AF8-8)
 	mov PER+AF8-CPU+AF8-VAR(current+AF8-task), +ACUAXw-ASM+AF8-DX
 	cmp TASK+AF8-addr+AF8-limit(+ACUAXw-ASM+AF8-DX),+ACUAXw-ASM+AF8-AX
 	jae bad+AF8-get+AF8-user+AF8-8
+-	MASK+AF8-NOSPEC +ACUAXw-ASM+AF8-DX, +ACUAXw-ASM+AF8-AX
 	ASM+AF8-STAC
 4:	movl -7(+ACUAXw-ASM+AF8-AX),+ACU-edx
 5:	movl -3(+ACUAXw-ASM+AF8-AX),+ACU-ecx
diff --git a/arch/x86/lib/usercopy+AF8-32.c b/arch/x86/lib/usercopy+AF8-32.=
c
index 1b377f734e64..7add8ba06887 100644
--- a/arch/x86/lib/usercopy+AF8-32.c
+-+-+- b/arch/x86/lib/usercopy+AF8-32.c
+AEAAQA- -331,12 +-331,12 +AEAAQA- do +AHs-									+AFw-
=20
 unsigned long +AF8AXw-copy+AF8-user+AF8-ll(void +ACo-to, const void +ACo-f=
rom, unsigned long n)
 +AHs-
-	stac()+ADs-
+-	+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 	if (movsl+AF8-is+AF8-ok(to, from, n))
 		+AF8AXw-copy+AF8-user(to, from, n)+ADs-
 	else
 		n +AD0- +AF8AXw-copy+AF8-user+AF8-intel(to, from, n)+ADs-
-	clac()+ADs-
+-	+AF8AXw-uaccess+AF8-end()+ADs-
 	return n+ADs-
 +AH0-
 EXPORT+AF8-SYMBOL(+AF8AXw-copy+AF8-user+AF8-ll)+ADs-
+AEAAQA- -344,7 +-344,7 +AEAAQA- EXPORT+AF8-SYMBOL(+AF8AXw-copy+AF8-user+AF=
8-ll)+ADs-
 unsigned long +AF8AXw-copy+AF8-from+AF8-user+AF8-ll+AF8-nocache+AF8-nozero=
(void +ACo-to, const void +AF8AXw-user +ACo-from,
 					unsigned long n)
 +AHs-
-	stac()+ADs-
+-	+AF8AXw-uaccess+AF8-begin+AF8-nospec()+ADs-
 +ACM-ifdef CONFIG+AF8-X86+AF8-INTEL+AF8-USERCOPY
 	if (n +AD4- 64 +ACYAJg- static+AF8-cpu+AF8-has(X86+AF8-FEATURE+AF8-XMM2))
 		n +AD0- +AF8AXw-copy+AF8-user+AF8-intel+AF8-nocache(to, from, n)+ADs-
+AEAAQA- -353,7 +-353,7 +AEAAQA- unsigned long +AF8AXw-copy+AF8-from+AF8-us=
er+AF8-ll+AF8-nocache+AF8-nozero(void +ACo-to, const void +AF8AXw-user +ACo=
-fr
 +ACM-else
 	+AF8AXw-copy+AF8-user(to, from, n)+ADs-
 +ACM-endif
-	clac()+ADs-
+-	+AF8AXw-uaccess+AF8-end()+ADs-
 	return n+ADs-
 +AH0-
 EXPORT+AF8-SYMBOL(+AF8AXw-copy+AF8-from+AF8-user+AF8-ll+AF8-nocache+AF8-no=
zero)+ADs-
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 1c65817673db..9731f1a255db 100644
--- a/include/linux/fdtable.h
+-+-+- b/include/linux/fdtable.h
+AEAAQA- -10,6 +-10,7 +AEAAQA-
 +ACM-include +ADw-linux/compiler.h+AD4-
 +ACM-include +ADw-linux/spinlock.h+AD4-
 +ACM-include +ADw-linux/rcupdate.h+AD4-
+-+ACM-include +ADw-linux/nospec.h+AD4-
 +ACM-include +ADw-linux/types.h+AD4-
 +ACM-include +ADw-linux/init.h+AD4-
 +ACM-include +ADw-linux/fs.h+AD4-
+AEAAQA- -81,9 +-82,11 +AEAAQA- struct dentry+ADs-
 static inline struct file +ACoAXwBf-fcheck+AF8-files(struct files+AF8-stru=
ct +ACo-files, unsigned int fd)
 +AHs-
 	struct fdtable +ACo-fdt +AD0- rcu+AF8-dereference+AF8-raw(files-+AD4-fdt)=
+ADs-
+-	struct file +AF8AXw-rcu +ACoAKg-fdp+ADs-
=20
-	if (fd +ADw- fdt-+AD4-max+AF8-fds)
-		return rcu+AF8-dereference+AF8-raw(fdt-+AD4-fd+AFs-fd+AF0-)+ADs-
+-	fdp +AD0- array+AF8-ptr(fdt-+AD4-fd, fd, fdt-+AD4-max+AF8-fds)+ADs-
+-	if (fdp)
+-		return rcu+AF8-dereference+AF8-raw(+ACo-fdp)+ADs-
 	return NULL+ADs-
 +AH0-
=20
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
new file mode 100644
index 000000000000..b8a9222e34d1
--- /dev/null
+-+-+- b/include/linux/nospec.h
+AEAAQA- -0,0 +-1,65 +AEAAQA-
+-// SPDX-License-Identifier: GPL-2.0
+-// Copyright(c) 2018 Intel Corporation. All rights reserved.
+-
+-+ACM-ifndef +AF8AXw-NOSPEC+AF8-H+AF8AXw-
+-+ACM-define +AF8AXw-NOSPEC+AF8-H+AF8AXw-
+-
+-+ACM-include +ADw-linux/jump+AF8-label.h+AD4-
+-+ACM-include +ADw-asm/barrier.h+AD4-
+-
+-/+ACo-
+- +ACo- If idx is negative or if idx +AD4- size then bit 63 is set in the =
mask,
+- +ACo- and the value of +AH4-(-1L) is zero. When the mask is zero, bounds=
 check
+- +ACo- failed, array+AF8-ptr will return NULL.
+- +ACo-/
+-+ACM-ifndef array+AF8-ptr+AF8-mask
+-static inline unsigned long array+AF8-ptr+AF8-mask(unsigned long idx, uns=
igned long sz)
+-+AHs-
+-	return +AH4-(long)(idx +AHw- (sz - 1 - idx)) +AD4APg- (BITS+AF8-PER+AF8-=
LONG - 1)+ADs-
+-+AH0-
+-+ACM-endif
+-
+-/+ACoAKg-
+- +ACo- array+AF8-ptr - Generate a pointer to an array element, ensuring
+- +ACo- the pointer is bounded under speculation to NULL.
+- +ACo-
+- +ACo- +AEA-base: the base of the array
+- +ACo- +AEA-idx: the index of the element, must be less than LONG+AF8-MAX
+- +ACo- +AEA-sz: the number of elements in the array, must be less than LO=
NG+AF8-MAX
+- +ACo-
+- +ACo- If +AEA-idx falls in the interval +AFs-0, +AEA-sz), returns the po=
inter to
+- +ACo- +AEA-arr+AFsAQA-idx+AF0-, otherwise returns NULL.
+- +ACo-/
+-+ACM-define array+AF8-ptr(base, idx, sz)					+AFw-
+-(+AHs-									+AFw-
+-	union +AHs- typeof(+ACo-(base)) +ACoAXw-ptr+ADs- unsigned long +AF8-bit+=
ADs- +AH0- +AF8AXw-u+ADs-	+AFw-
+-	typeof(+ACo-(base)) +ACoAXw-arr +AD0- (base)+ADs-					+AFw-
+-	unsigned long +AF8-i +AD0- (idx)+ADs-					+AFw-
+-	unsigned long +AF8-mask +AD0- array+AF8-ptr+AF8-mask(+AF8-i, (sz))+ADs-	=
		+AFw-
+-									+AFw-
+-	+AF8AXw-u.+AF8-ptr +AD0- +AF8-arr +- +AF8-i+ADs-						+AFw-
+-	+AF8AXw-u.+AF8-bit +ACYAPQ- +AF8-mask+ADs-						+AFw-
+-	+AF8AXw-u.+AF8-ptr+ADs-							+AFw-
+-+AH0-)
+-
+-/+ACoAKg-
+- +ACo- array+AF8-idx - Generate a pointer to an array index, ensuring the
+- +ACo- pointer is bounded under speculation to NULL.
+- +ACo-
+- +ACo- +AEA-idx: the index of the element, must be less than LONG+AF8-MAX
+- +ACo- +AEA-sz: the number of elements in the array, must be less than LO=
NG+AF8-MAX
+- +ACo-
+- +ACo- If +AEA-idx falls in the interval +AFs-0, +AEA-sz), returns +ACYAQ=
A-idx otherwise
+- +ACo- returns NULL.
+- +ACo-/
+-+ACM-define array+AF8-idx(idx, sz)						+AFw-
+-(+AHs-									+AFw-
+-	union +AHs- typeof((idx)) +ACoAXw-ptr+ADs- unsigned long +AF8-bit+ADs- +=
AH0- +AF8AXw-u+ADs-		+AFw-
+-	typeof(idx) +ACoAXw-i +AD0- +ACY-(idx)+ADs-					+AFw-
+-	unsigned long +AF8-mask +AD0- array+AF8-ptr+AF8-mask(+ACoAXw-i, (sz))+AD=
s-		+AFw-
+-									+AFw-
+-	+AF8AXw-u.+AF8-ptr +AD0- +AF8-i+ADs-							+AFw-
+-	+AF8AXw-u.+AF8-bit +ACYAPQ- +AF8-mask+ADs-						+AFw-
+-	+AF8AXw-u.+AF8-ptr+ADs-							+AFw-
+-+AH0-)
+-+ACM-endif /+ACo- +AF8AXw-NOSPEC+AF8-H+AF8AXw- +ACo-/
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2b3dbcd40e46..202cb1dc03ee 100644
--- a/net/wireless/nl80211.c
+-+-+- b/net/wireless/nl80211.c
+AEAAQA- -16,6 +-16,7 +AEAAQA-
 +ACM-include +ADw-linux/nl80211.h+AD4-
 +ACM-include +ADw-linux/rtnetlink.h+AD4-
 +ACM-include +ADw-linux/netlink.h+AD4-
+-+ACM-include +ADw-linux/nospec.h+AD4-
 +ACM-include +ADw-linux/etherdevice.h+AD4-
 +ACM-include +ADw-net/net+AF8-namespace.h+AD4-
 +ACM-include +ADw-net/genetlink.h+AD4-
+AEAAQA- -2056,20 +-2057,23 +AEAAQA- static const struct nla+AF8-policy txq=
+AF8-params+AF8-policy+AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-MAX +- 1+AF0- +AD0-=
 +AHs-
 static int parse+AF8-txq+AF8-params(struct nlattr +ACo-tb+AFsAXQ-,
 			    struct ieee80211+AF8-txq+AF8-params +ACo-txq+AF8-params)
 +AHs-
+-	u8 ac, +ACo-idx+ADs-
+-
 	if (+ACE-tb+AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-AC+AF0- +AHwAfA- +ACE-tb+AFs=
-NL80211+AF8-TXQ+AF8-ATTR+AF8-TXOP+AF0- +AHwAfA-
 	    +ACE-tb+AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-CWMIN+AF0- +AHwAfA- +ACE-tb+=
AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-CWMAX+AF0- +AHwAfA-
 	    +ACE-tb+AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-AIFS+AF0-)
 		return -EINVAL+ADs-
=20
-	txq+AF8-params-+AD4-ac +AD0- nla+AF8-get+AF8-u8(tb+AFs-NL80211+AF8-TXQ+AF=
8-ATTR+AF8-AC+AF0-)+ADs-
+-	ac +AD0- nla+AF8-get+AF8-u8(tb+AFs-NL80211+AF8-TXQ+AF8-ATTR+AF8-AC+AF0-)=
+ADs-
 	txq+AF8-params-+AD4-txop +AD0- nla+AF8-get+AF8-u16(tb+AFs-NL80211+AF8-TXQ=
+AF8-ATTR+AF8-TXOP+AF0-)+ADs-
 	txq+AF8-params-+AD4-cwmin +AD0- nla+AF8-get+AF8-u16(tb+AFs-NL80211+AF8-TX=
Q+AF8-ATTR+AF8-CWMIN+AF0-)+ADs-
 	txq+AF8-params-+AD4-cwmax +AD0- nla+AF8-get+AF8-u16(tb+AFs-NL80211+AF8-TX=
Q+AF8-ATTR+AF8-CWMAX+AF0-)+ADs-
 	txq+AF8-params-+AD4-aifs +AD0- nla+AF8-get+AF8-u8(tb+AFs-NL80211+AF8-TXQ+=
AF8-ATTR+AF8-AIFS+AF0-)+ADs-
=20
-	if (txq+AF8-params-+AD4-ac +AD4APQ- NL80211+AF8-NUM+AF8-ACS)
+-	idx +AD0- array+AF8-idx(ac, NL80211+AF8-NUM+AF8-ACS)+ADs-
+-	if (+ACE-idx)
 		return -EINVAL+ADs-
-
+-	txq+AF8-params-+AD4-ac +AD0- +ACo-idx+ADs-
 	return 0+ADs-
 +AH0-
 =
