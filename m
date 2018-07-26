Date: Thu, 26 Jul 2018 10:55:48 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 0/2] Stackleak for arm64
Message-ID: <20180726095548.GB28088@arm.com>
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
 <20180720214154.2940-1-labbott@redhat.com>
 <20180724163807.GE25888@arm.com>
 <20180725114954.GD30289@arm.com>
 <fbf890f6-7424-362e-95dd-223262e5f19e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbf890f6-7424-362e-95dd-223262e5f19e@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Wed, Jul 25, 2018 at 03:05:58PM -0700, Laura Abbott wrote:
> On 07/25/2018 04:49 AM, Will Deacon wrote:
> >arch/arm64/kernel/sdei.c: At top level:
> >arch/arm64/kernel/sdei.c:127:6: error: conflicting types for ‘_on_sdei_stack’
> >  bool _on_sdei_stack(unsigned long sp,
> >       ^~~~~~~~~~~~~~
> >In file included from ./include/linux/arm_sdei.h:14:0,
> >                  from arch/arm64/kernel/sdei.c:5:
> >./arch/arm64/include/asm/sdei.h:45:6: note: previous declaration of ‘_on_sdei_stack’ was here
> >  bool _on_sdei_stack(unsigned long sp, struct stack_info *info);
> >       ^~~~~~~~~~~~~~
> >arch/arm64/kernel/sdei.c: In function ‘_on_sdei_stack’:
> >arch/arm64/kernel/sdei.c:136:33: error: ‘info’ undeclared (first use in this function); did you mean ‘int’?
> >   if (on_sdei_critical_stack(sp, info))
> >                                  ^~~~
> >                                  int
> >arch/arm64/kernel/sdei.c:131:21: warning: unused variable ‘high’ [-Wunused-variable]
> >   unsigned long low, high;
> >                      ^~~~
> >arch/arm64/kernel/sdei.c:131:16: warning: unused variable ‘low’ [-Wunused-variable]
> >   unsigned long low, high;
> >                 ^~~
> >make[1]: *** [arch/arm64/kernel/sdei.o] Error 1
> >make[1]: *** Waiting for unfinished jobs....
> >make: *** [arch/arm64/kernel] Error 2
> >
> 
> Ugh this was a failure that I missed folding in, sorry about that

That's ok, thanks for the quick fixup. I'll fold it in and push this out
later on.

Cheers,

Will
