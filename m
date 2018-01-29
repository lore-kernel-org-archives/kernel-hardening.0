MIME-Version: 1.0
In-Reply-To: <20180128091437.4lbll5bev7mgdpug@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703973427.26578.15693075353773519333.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128091437.4lbll5bev7mgdpug@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 12:41:00 -0800
Message-ID: <CAPcyv4hmkJyFgCBCXR8A1ykzk1tsxX-Lg4qgimhGxne=iG1Hzg@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] x86: introduce __uaccess_begin_nospec and ifence
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 1:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> --- a/arch/x86/include/asm/uaccess.h
>> +++ b/arch/x86/include/asm/uaccess.h
>> @@ -124,6 +124,11 @@ extern int __get_user_bad(void);
>>
>>  #define __uaccess_begin() stac()
>>  #define __uaccess_end()   clac()
>> +#define __uaccess_begin_nospec()     \
>> +({                                   \
>> +     stac();                         \
>> +     ifence();                       \
>> +})
>
> BTW., wouldn't it be better to switch the barrier order here, i.e. to do:
>
>         ifence();                       \
>         stac();                         \
>
> ?
>
> The reason is that stac()/clac() is usually paired, so there's a chance with short
> sequences that it would resolve with 'no externally visible changes to flags'.
>
> Also, there's many cases where flags are modified _inside_ the STAC/CLAC section,
> so grouping them together inside a speculation atom could be beneficial.

I'm struggling a bit to grok this. Are you referring to the state of
the flags from the address limit comparison? That's the result that
needs fencing before speculative execution leaks to to the user
pointer de-reference.

> The flip side is that if the MFENCE stalls the STAC that is ahead of it could be
> processed for 'free' - while it's always post barrier with my suggestion.

This 'for free' aspect is what I aiming for.

>
> But in any case it would be nice to see a discussion of this aspect in the
> changelog, even if the patch does not change.

I'll add a note to the changelog that having the fence after the
'stac' hopefully allows some overlap of the cost of 'stac' and the
flushing of the instruction pipeline.
