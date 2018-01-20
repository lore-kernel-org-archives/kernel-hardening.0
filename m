MIME-Version: 1.0
In-Reply-To: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 19 Jan 2018 22:58:44 -0800
Message-ID: <CAPcyv4iBHTahi66deUT1iSPpA2W2wjYZSaiUYUjpdK10d5Rt7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 00/10] prevent bounds-check bypass via speculative execution
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Andrew Honig <ahonig@google.com>, Alan Cox <alan@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jim Mattson <jmattson@google.com>, Christian Lamparter <chunkeey@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 4:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Changes since v3 [1]
> * Drop 'ifence_array_ptr' and associated compile-time + run-time
>   switching and just use the masking approach all the time.
>
> * Convert 'get_user' to use pointer sanitization via masking rather than
>   lfence. '__get_user' and associated paths still rely on
>   lfence. (Linus)
>
>       "Basically, the rule is trivial: find all 'stac' users, and use
>        address masking if those users already integrate the limit
>        check, and lfence they don't."
>
> * At syscall entry sanitize the syscall number under speculation
>   to remove a user controlled pointer de-reference in kernel
>   space.  (Linus)
>
> * Fix a raw lfence in the kvm code (added for v4.15-rc8) to use
>   'array_ptr'.
>
> * Propose 'array_idx' as a way to sanitize user input that is
>   later used as an array index, but where the validation is
>   happening in a different code block than the array reference.
>   (Christian).
>
> * Fix grammar in speculation.txt (Kees)
>
> ---
>
> Quoting Mark's original RFC:
>
> "Recently, Google Project Zero discovered several classes of attack
> against speculative execution. One of these, known as variant-1, allows
> explicit bounds checks to be bypassed under speculation, providing an
> arbitrary read gadget. Further details can be found on the GPZ blog [2]
> and the Documentation patch in this series."
>
> A precondition of using this attack on the kernel is to get a user
> controlled pointer de-referenced (under speculation) in privileged code.
> The primary source of user controlled pointers in the kernel is the
> arguments passed to 'get_user' and '__get_user'. An example of other
> user controlled pointers are user-controlled array / pointer offsets.
>
> Better tooling is needed to find more arrays / pointers with user
> controlled indices / offsets that can be converted to use 'array_ptr' or
> 'array_idx'. A few are included in this set, and these are not expected
> to be complete. That said, the 'get_user' protections raise the bar on
> finding a vulnerable gadget in the kernel.
>
> These patches are also available via the 'nospec-v4' git branch here:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec-v4

I've pushed out a nospec-v4.1 with the below minor cleanup, a fixup of
the changelog for "kvm, x86: fix spectre-v1 mitigation", and added
Paolo's ack.

     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec-v4.1

diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index 8af35be1869e..b8a9222e34d1 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -37,7 +37,7 @@ static inline unsigned long array_ptr_mask(unsigned
long idx, unsigned long sz)
        unsigned long _i = (idx);                                       \
        unsigned long _mask = array_ptr_mask(_i, (sz));                 \
                                                                        \
-       __u._ptr = _arr + (_i & _mask);                                 \
+       __u._ptr = _arr + _i;                                           \
        __u._bit &= _mask;                                              \
        __u._ptr;                                                       \
 })
