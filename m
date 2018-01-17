MIME-Version: 1.0
In-Reply-To: <20180117062800.GU13338@ZenIV.linux.org.uk>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CAPcyv4g94iysWqz64KNk=HDdx6+b2e0O-rRrnFZDqfNSR3Xrjg@mail.gmail.com> <20180117062800.GU13338@ZenIV.linux.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Jan 2018 22:50:01 -0800
Message-ID: <CAPcyv4jn6xHNB2DevoFEzkfpnKCd7u8UdA+TmVPtbO08TjzFWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 16, 2018 at 10:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jan 16, 2018 at 08:30:17PM -0800, Dan Williams wrote:
>> On Tue, Jan 16, 2018 at 2:23 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Sat, Jan 13, 2018 at 11:33 AM, Linus Torvalds
>> [..]
>> > I'll respin this set along those lines, and drop the ifence bits.
>>
>> So now I'm not so sure. Yes, get_user_{1,2,4,8} can mask the pointer
>> with the address limit result, but this doesn't work for the
>> access_ok() + __get_user() case. We can either change the access_ok()
>> calling convention to return a properly masked pointer to be used in
>> subsequent calls to __get_user(), or go with lfence on every
>> __get_user call. There seem to be several drivers that open code
>> copy_from_user() with __get_user loops, so the 'fence every
>> __get_user' approach might have noticeable overhead. On the other hand
>> the access_ok conversion, while it could be scripted with coccinelle,
>> is ~300 sites (VERIFY_READ), if you're concerned about having
>> something small to merge for 4.15.
>>
>> I think the access_ok() conversion to return a speculation sanitized
>> pointer or NULL is the way to go unless I'm missing something simpler.
>> Other ideas?
>
> What masked pointer?

The pointer value that is masked under speculation.

   diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
   index c97d935a29e8..4c378b485399 100644
   --- a/arch/x86/lib/getuser.S
   +++ b/arch/x86/lib/getuser.S
   @@ -40,6 +40,8 @@ ENTRY(__get_user_1)
           mov PER_CPU_VAR(current_task), %_ASM_DX
           cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
           jae bad_get_user
   +       sbb %_ASM_DX,%_ASM_DX
   +       and %_ASM_DX,%_ASM_AX
           ASM_STAC
    1:     movzbl (%_ASM_AX),%edx
           xor %eax,%eax

...i.e %_ASM_AX is guaranteed to be zero if userspace tries to cause
speculation with an address above the limit. The proposal is make
access_ok do that same masking so we never speculate on pointers from
userspace aimed at kernel memory.

> access_ok() exists for other architectures as well,

I'd modify those as well...

> and the fewer callers remain outside of arch/*, the better.
>
> Anything that open-codes copy_from_user() that way is *ALREADY* fucked if
> it cares about the overhead - recent x86 boxen will have slowdown from
> hell on stac()/clac() pairs.  Anything like that on a hot path is already
> deep in trouble and needs to be found and fixed.  What drivers would those
> be?

So I took a closer look and the pattern is not copy_from_user it's
more like __get_user + write-to-hardware loops. If the performance is
already expected to be bad for those then perhaps an lfence each loop
iteration won't be much worse. It's still a waste because the lfence
is only needed once after the access_ok.

> We don't have that many __get_user() users left outside of arch/*
> anymore...
