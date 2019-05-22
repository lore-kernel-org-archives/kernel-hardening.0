MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-4-thgarnie@chromium.org>
 <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>
In-Reply-To: <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 22 May 2019 08:57:33 -0700
Message-ID: <CAJcbSZEYZLj_UQCQZzqxiOJEoWb2EzuUgaaFCkUBBFuKepHh8w@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] x86: Add macro to get symbol address for PIE support
Content-Type: text/plain; charset="UTF-8"
To: "H . Peter Anvin" <hpa@zytor.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 20, 2019 at 8:13 PM <hpa@zytor.com> wrote:
>
> On May 20, 2019 4:19:28 PM PDT, Thomas Garnier <thgarnie@chromium.org> wrote:
> >From: Thomas Garnier <thgarnie@google.com>
> >
> >Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
> >to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
> >compatible with PIE.
> >
> >Signed-off-by: Thomas Garnier <thgarnie@google.com>
> >---
> > arch/x86/include/asm/asm.h | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> >index 3ff577c0b102..3a686057e882 100644
> >--- a/arch/x86/include/asm/asm.h
> >+++ b/arch/x86/include/asm/asm.h
> >@@ -30,6 +30,7 @@
> > #define _ASM_ALIGN    __ASM_SEL(.balign 4, .balign 8)
> >
> > #define _ASM_MOV      __ASM_SIZE(mov)
> >+#define _ASM_MOVABS   __ASM_SEL(movl, movabsq)
> > #define _ASM_INC      __ASM_SIZE(inc)
> > #define _ASM_DEC      __ASM_SIZE(dec)
> > #define _ASM_ADD      __ASM_SIZE(add)
>
> This is just about *always* wrong on x86-86. We should be using leaq sym(%rip),%reg. If it isn't reachable by leaq, then it is a non-PIE symbol like percpu. You do have to keep those distinct!

Yes, I agree. This patch is just having a shortcut when it is a
non-PIE symbol. The other patches try to separate the use cases where
a leaq sym(%rip) would work versus the need for a movabsq. There are
multiple cases where relative references are not possible because the
memory layout is different (hibernation, early boot or others).

> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
