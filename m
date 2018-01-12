MIME-Version: 1.0
In-Reply-To: <20180112185815.meiwnnb5vmnrbsdt@treble>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571802258.27429.932636277047687877.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112175109.yoz4jaaipztdj34k@treble> <CAPcyv4heW2FqxpCa0NZeTsa5V7pgpzA-MdHYJA+y9C5L2GTP9w@mail.gmail.com>
 <20180112185815.meiwnnb5vmnrbsdt@treble>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Jan 2018 11:26:30 -0800
Message-ID: <CAPcyv4jm7S+8ezntAo2LeOGshPdpt616RNOambOL6espzBYUvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 07/19] x86: introduce __uaccess_begin_nospec and ASM_IFENCE
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 10:58 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Fri, Jan 12, 2018 at 10:21:43AM -0800, Dan Williams wrote:
>> > That just sounds wrong.  What if the speculation starts *after* the
>> > access_ok() check?  Then the barrier has no purpose.
>> >
>> > Most access_ok/get_user/copy_from_user calls are like this:
>> >
>> >   if (copy_from_user(...uptr..))  /* or access_ok() or get_user() */
>> >         return -EFAULT;
>> >
>> > So in other words, the usercopy function is called *before* the branch.
>> >
>> > But to halt speculation, the lfence needs to come *after* the branch.
>> > So putting lfences *before* the branch doesn't solve anything.
>> >
>> > So what am I missing?
>>
>> We're trying to prevent a pointer under user control from being
>> de-referenced inside the kernel, before we know it has been limited to
>> something safe. In the following sequence the branch we are worried
>> about speculating is the privilege check:
>>
>> if (access_ok(uptr))  /* <--- Privelege Check */
>>     if (copy_from_user_(uptr))
>>
>> The cpu can speculatively skip that access_ok() check and cause a read
>> of kernel memory.
>
> Converting your example code to assembly:
>
>         call    access_ok # no speculation which started before this point is allowed to continue past this point
>         test    %rax, %rax
>         jne     error_path
> dereference_uptr:
>         (do nefarious things with the user pointer)
>
> error_path:
>         mov -EINVAL, %rax
>         ret
>
> So the CPU is still free to speculately execute the dereference_uptr
> block because the lfence was before the 'jne error_path' branch.

By the time we get to de-reference uptr we know it is not pointing at
kernel memory, because access_ok would have failed and the cpu would
have waited for that failure result before doing anything else.

Now the vulnerability that still exists after this fence is if we do
something with the value returned from de-referencing that pointer.
I.e. if we do:

get_user(val, uptr);
if (val < array_max)
    array[val];

...then we're back to having a user controlled pointer in the kernel.
This is the point where we need array_ptr() to sanitize things.
