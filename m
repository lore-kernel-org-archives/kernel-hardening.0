Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC561CD14829@ORSMSX103.amr.corp.intel.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <CAGXu5j+EtVPabrwPXU0W8yJ5Fg0H0Nc6aPjJqqNOSx+m+TBu2Q@mail.gmail.com> <476DC76E7D1DF2438D32BFADF679FC561CD14829@ORSMSX103.amr.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 6 Oct 2016 14:04:41 -0700
Message-ID: <CAGXu5jK6JFjnp25WopT=gqjMG2rb+MJJmsiX8t+D40jgs4640A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 6, 2016 at 8:18 AM, Roberts, William C
<william.c.roberts@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: keescook@google.com [mailto:keescook@google.com] On Behalf Of Kees
>> Cook
>> Sent: Wednesday, October 5, 2016 3:34 PM
>> To: Roberts, William C <william.c.roberts@intel.com>
>> Cc: kernel-hardening@lists.openwall.com; Jonathan Corbet <corbet@lwn.net>;
>> linux-doc@vger.kernel.org; LKML <linux-kernel@vger.kernel.org>; Nick
>> Desaulniers <ndesaulniers@google.com>; Dave Weinstein <olorin@google.com>
>> Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
>>
>> On Wed, Oct 5, 2016 at 11:04 AM,  <william.c.roberts@intel.com> wrote:
>> > From: William Roberts <william.c.roberts@intel.com>
>> >
>> > Some out-of-tree modules do not use %pK and just use %p, as it's the
>> > common C paradigm for printing pointers. Because of this,
>> > kptr_restrict has no affect on the output and thus, no way to contain
>> > the kernel address leak.
>>
>> Solving this is certainly a good idea -- I'm all for finding a solid solution.
>>
>> > Introduce kptr_restrict level 3 that causes the kernel to treat %p as
>> > if it was %pK and thus always prints zeros.
>>
>> I'm worried that this could break kernel internals where %p is being used and not
>> exposed to userspace. Maybe those situations don't exist...
>>
>> Regardless, I would rather do what Grsecurity has done in this area, and whitelist
>> known-safe values instead. For example, they have %pP for approved pointers,
>> and %pX for approved
>> dereference_function_descriptor() output. Everything else is censored if it is a
>> value in kernel memory and destined for a user-space memory
>> buffer:
>>
>>         if ((unsigned long)ptr > TASK_SIZE && *fmt != 'P' && *fmt != 'X' && *fmt !=
>> 'K' && is_usercopy_object(buf)) {
>>                 printk(KERN_ALERT "grsec: kernel infoleak detected!
>> Please report this log to spender@grsecurity.net.\n");
>>                 dump_stack();
>>                 ptr = NULL;
>>         }
>>
>> The "is_usercopy_object()" test is something we can add, which is testing for a
>> new SLAB flag that is used to mark slab caches as either used by user-space or
>> not, which is done also through whitelisting.
>> (For more details on this, see:
>> http://www.openwall.com/lists/kernel-hardening/2016/06/08/10)
>>
>> Would you have time/interest to add the slab flags and is_usercopy_object()?
>> The hardened usercopy part of the slab whitelisting can be separate, since it likely
>> needs a different usercopy interface to sanely integrate with upstream.
>
> A couple of questions off hand:
> 1. What about bss statics? I am assuming that when the loader loads up a module
>      That it's dynamically allocating the .bss section or some equivalent. I would
>      Also assume the method you describe would catch that, is that correct?
>
> 2. What about stack variables?

It looks like what Grsecurity is doing is saying "if the address is
outside of user-space" (" > TASK_SIZE") and it's not whitelisted ('P',
'X') and it's going to land in a user-space buffer
("is_usercopy_object()", censor it. ("K" is already censored --
they're just optimizing to avoid re-checking it needlessly.)

So, in this case, all kernel memory, bss and stack included, would be
outside the user-space address range. (I am curious, however, how to
apply this to an architecture like s390 which has overlapping address
ranges... probably the TASK_SIZE test needs to use some other "is in
kernel memory" check that compiles down to TASK_SIZE on non-s390, and
DTRT on s390, etc.)

-Kees

-- 
Kees Cook
Nexus Security
