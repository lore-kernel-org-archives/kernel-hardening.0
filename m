Date: Wed, 25 Jul 2018 12:49:54 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 0/2] Stackleak for arm64
Message-ID: <20180725114954.GD30289@arm.com>
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
 <20180720214154.2940-1-labbott@redhat.com>
 <20180724163807.GE25888@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180724163807.GE25888@arm.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Tue, Jul 24, 2018 at 05:38:07PM +0100, Will Deacon wrote:
> On Fri, Jul 20, 2018 at 02:41:52PM -0700, Laura Abbott wrote:
> > This is the version of stackleak for arm64, hopefully ready for queueing
> 
> Thanks. I'll push these into linux-next tomorrow, once I've had a chance
> to test my conflict resolution in entry.S.

I've run into a couple of issues with this series:

1. I had to install libmpc-dev to get GCC_PLUGINS to appear, otherwise the
   hostcc check would silently fail. I guess that's a general observation,
   but it might be nice to print a message about the missing dependencies.

2. It breaks arm64 allmodconfig build. Log below.

Please can you take a look at the build failure? Otherwise, the patches
look good to me.

Cheers,

Will

--->8

arch/arm64/kernel/sdei.c: In function ‘on_sdei_normal_stack’:
arch/arm64/kernel/sdei.c:101:7: error: dereferencing pointer to incomplete type ‘struct stack_info’
   info->low = low;
       ^~
arch/arm64/kernel/sdei.c:103:16: error: ‘STACK_TYPE_SDEI_NORMAL’ undeclared (first use in this function); did you mean ‘SCHED_NORMAL’?
   info->type = STACK_TYPE_SDEI_NORMAL;
                ^~~~~~~~~~~~~~~~~~~~~~
                SCHED_NORMAL
arch/arm64/kernel/sdei.c:103:16: note: each undeclared identifier is reported only once for each function it appears in
arch/arm64/kernel/sdei.c: In function ‘on_sdei_critical_stack’:
arch/arm64/kernel/sdei.c:121:16: error: ‘STACK_TYPE_SDEI_CRITICAL’ undeclared (first use in this function)
   info->type = STACK_TYPE_SDEI_CRITICAL;
                ^~~~~~~~~~~~~~~~~~~~~~~~
arch/arm64/kernel/sdei.c: At top level:
arch/arm64/kernel/sdei.c:127:6: error: conflicting types for ‘_on_sdei_stack’
 bool _on_sdei_stack(unsigned long sp,
      ^~~~~~~~~~~~~~
In file included from ./include/linux/arm_sdei.h:14:0,
                 from arch/arm64/kernel/sdei.c:5:
./arch/arm64/include/asm/sdei.h:45:6: note: previous declaration of ‘_on_sdei_stack’ was here
 bool _on_sdei_stack(unsigned long sp, struct stack_info *info);
      ^~~~~~~~~~~~~~
arch/arm64/kernel/sdei.c: In function ‘_on_sdei_stack’:
arch/arm64/kernel/sdei.c:136:33: error: ‘info’ undeclared (first use in this function); did you mean ‘int’?
  if (on_sdei_critical_stack(sp, info))
                                 ^~~~
                                 int
arch/arm64/kernel/sdei.c:131:21: warning: unused variable ‘high’ [-Wunused-variable]
  unsigned long low, high;
                     ^~~~
arch/arm64/kernel/sdei.c:131:16: warning: unused variable ‘low’ [-Wunused-variable]
  unsigned long low, high;
                ^~~
make[1]: *** [arch/arm64/kernel/sdei.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [arch/arm64/kernel] Error 2
