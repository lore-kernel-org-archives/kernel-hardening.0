Date: Mon, 14 Aug 2017 18:42:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170814174259.GA25890@leverpostej>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-11-git-send-email-mark.rutland@arm.com>
 <20170814171338.gvtn76awussgxctn@armageddon.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814171338.gvtn76awussgxctn@armageddon.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCH 10/14] arm64: assembler: allow adr_this_cpu to use the
 stack pointer
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, luto@amacapital.net, james.morse@arm.com, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 06:13:39PM +0100, Catalin Marinas wrote:
> On Mon, Aug 07, 2017 at 07:36:01PM +0100, Mark Rutland wrote:

> >  	.macro adr_this_cpu, dst, sym, tmp
> > -	adr_l	\dst, \sym
> > +	adrp	\tmp, \sym
> > +	add	\dst, \tmp, #:lo12:\sym
> >  	mrs	\tmp, tpidr_el1
> >  	add	\dst, \dst, \tmp
> >  	.endm
> 
> Nitpick: it may be worth adding an #ifndef MODULE around these macros,
> together with a comment, just in case. There are other macros in this
> file like adr_l which are used in modules (crypto).

I've folded in the below, in keeping with the other MODULE fallbacks.

Thanks,
Mark.

---->8----
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 4775af5..50c5592 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -230,13 +230,18 @@
        .endm
 
        /*
-        * @dst: Result of per_cpu(sym, smp_processor_id())
+        * @dst: Result of per_cpu(sym, smp_processor_id()), can be SP for
+        *       non-module code
         * @sym: The name of the per-cpu variable
         * @tmp: scratch register
         */
        .macro adr_this_cpu, dst, sym, tmp
+#ifndef MODULE
        adrp    \tmp, \sym
        add     \dst, \tmp, #:lo12:\sym
+#else
+       adr_l   \tmp, \sym
+#endif
        mrs     \tmp, tpidr_el1
        add     \dst, \dst, \tmp
        .endm
