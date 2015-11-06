Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_g07h_LhAx0M_xS5Km7kzrFXf7R-tbdhzcYicZna+pjkg@mail.gmail.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<CAEXv5_g07h_LhAx0M_xS5Km7kzrFXf7R-tbdhzcYicZna+pjkg@mail.gmail.com>
Date: Fri, 6 Nov 2015 11:37:27 -0800
Message-ID: <CAGXu5jKopMCQ0ROh3XXZn_POpfOcicvsq00w77kXaowbVERWtQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 5, 2015 at 1:14 PM, David Windsor <dave@0x4141.net> wrote:
> Hi,
>
> I've done some work towards adding PAX_REFCOUNT to Ubuntu previously [1], so
> I can resurrect those patches.  Note that those patches were directly
> cherrypicked from PaX/grsec, without any sort of controls (sysctl, proc,
> ioctl or otherwise) governing runtime behavior of this feature.  I can add
> them if desired.
>
> I also proposed a patch for adding overflow protection to kref [2], but that
> patch was ultimately shot down.  Point being, I have some related patches
> laying around that directly relate to refcount-based protection which might
> be useful here.

Yes, I remember this earlier attempt. Let's dust this off and try
again. If you could find some good examples of exploits this stops,
that could help people understand its purpose (if they don't
immediately see it to start with).

It might be nice to extract PAX_REFCOUNT as-is first, build tests for
it (for example, adding tests to CONFIG_LKDTM[1]), and then see what
about it needs polishing for it to go upstream (bikeshedding, docs,
sysctl, etc).

-Kees

[1] http://lwn.net/Articles/663531/

>
> Thanks,
> David Windsor
>
> [1]
> https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg3420821.html
> [2] https://lkml.org/lkml/2012/2/24/331
>
> On Thu, Nov 5, 2015 at 3:59 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> I'm organizing a community of people to work on the various kernel
>> self-protection technologies (most of which are found in PaX and
>> Grsecurity). I'm building on the presentation I gave at Kernel Summit
>> where I sought to convince the other upstream Linux kernel developers
>> that security is more than fixing bugs, and that we need to bring in
>> proactive defenses:
>> http://lwn.net/Articles/662219/
>>
>> This is especially highlighted by the Washington Post article today:
>>
>> http://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-the-kernel-of-the-argument/
>>
>> Between the companies that recognize the critical nature of this work,
>> and with Linux Foundation's Core Infrastructure Initiative happy to
>> start funding specific work in this area, I think we can really make a
>> dent.
>>
>> Let's start the work. I've built some wiki pages around my slides,
>> where we can take notes, list examples, and coordinate:
>> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>>
>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>> gcc plugin, which will also get us the gcc plugin infrastructure.
>> Other people, please speak up on what you'd like to tackle.
>>
>> I recommend PAX_REFCOUNT, PAX_USERCOPY, and GRKERNSEC_KSTACKOVERFLOW
>> for some non-plugin stuff to look at.
>>
>> Once we've got plugins, then we should look at PAX_MEMORY_STACKLEAK
>> and PAX_CONSTIFY_PLUGIN.
>>
>> If you're feeling like disrupting people who depend on debugging, do
>> GRKERNSEC_HIDESYM.
>>
>> If you're feeling especially bold, start on PAX_KERNEXEC and follow it
>> up with PAX_MEMORY_UDEREF.
>>
>> Of course, there's plenty of other things, and tons I haven't listed
>> in the wiki -- please add them and bring them up for discussion here.
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
>



-- 
Kees Cook
Chrome OS Security
