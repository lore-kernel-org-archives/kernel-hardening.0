Date: Mon, 20 May 2019 20:12:55 -0700
In-Reply-To: <20190520231948.49693-4-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-4-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 03/12] x86: Add macro to get symbol address for PIE support
From: hpa@zytor.com
Message-ID: <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>
To: Thomas Garnier <thgarnie@chromium.org>, kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On May 20, 2019 4:19:28 PM PDT, Thomas Garnier <thgarnie@chromium=2Eorg> wr=
ote:
>From: Thomas Garnier <thgarnie@google=2Ecom>
>
>Add a new _ASM_MOVABS macro to fetch a symbol address=2E It will be used
>to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
>compatible with PIE=2E
>
>Signed-off-by: Thomas Garnier <thgarnie@google=2Ecom>
>---
> arch/x86/include/asm/asm=2Eh | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/include/asm/asm=2Eh b/arch/x86/include/asm/asm=2Eh
>index 3ff577c0b102=2E=2E3a686057e882 100644
>--- a/arch/x86/include/asm/asm=2Eh
>+++ b/arch/x86/include/asm/asm=2Eh
>@@ -30,6 +30,7 @@
> #define _ASM_ALIGN	__ASM_SEL(=2Ebalign 4, =2Ebalign 8)
>=20
> #define _ASM_MOV	__ASM_SIZE(mov)
>+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
> #define _ASM_INC	__ASM_SIZE(inc)
> #define _ASM_DEC	__ASM_SIZE(dec)
> #define _ASM_ADD	__ASM_SIZE(add)

This is just about *always* wrong on x86-86=2E We should be using leaq sym=
(%rip),%reg=2E If it isn't reachable by leaq, then it is a non-PIE symbol l=
ike percpu=2E You do have to keep those distinct!
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
