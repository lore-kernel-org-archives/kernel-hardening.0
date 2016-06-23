Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160623193358.GL9922@io.lakedaemon.net>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
 <20160622124707.GC9922@io.lakedaemon.net> <CAJcbSZHbGJBhTMeAEJF4VVazYypDCO=UFJpi8y0kXKrdM=WXQA@mail.gmail.com>
 <CAGXu5jK_42d+jkPr4Ck0iL52-ignY9gq-eUZ73_YuhKJERrRxA@mail.gmail.com> <20160623193358.GL9922@io.lakedaemon.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Jun 2016 12:58:00 -0700
Message-ID: <CAGXu5jJpFPuOrKSWT_H1oeTDObQKcgqL9ZwAHUV7y9=how_n9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v7 0/9] x86/mm: memory area address KASLR
To: Jason Cooper <jason@lakedaemon.net>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Garnier <thgarnie@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 12:33 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> Hey Kees, Thomas,
>
> On Wed, Jun 22, 2016 at 10:05:51AM -0700, Kees Cook wrote:
>> On Wed, Jun 22, 2016 at 8:59 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> > On Wed, Jun 22, 2016 at 5:47 AM, Jason Cooper <jason@lakedaemon.net> wrote:
>> >> Hey Kees,
>> >>
>> >> On Tue, Jun 21, 2016 at 05:46:57PM -0700, Kees Cook wrote:
>> >>> Notable problems that needed solving:
>> >> ...
>> >>>  - Reasonable entropy is needed early at boot before get_random_bytes()
>> >>>    is available.
>> >>
>> >> This series is targetting x86, which typically has RDRAND/RDSEED
>> >> instructions.  Are you referring to other arches?  Older x86?  Also,
>> >> isn't this the same requirement for base address KASLR?
>> >>
>> >> Don't get me wrong, I want more diverse entropy sources available
>> >> earlier in the boot process as well. :-)  I'm just wondering what's
>> >> different about this series vs base address KASLR wrt early entropy
>> >> sources.
>> >>
>> >
>> > I think Kees was referring to the refactor I did to get the similar
>> > entropy generation than KASLR module randomization. Our approach was
>> > to provide best entropy possible even if you have an older processor
>> > or under virtualization without support for these instructions.
>> > Unfortunately common on companies with a large number of older
>> > machines.
>>
>> Right, the memory offset KASLR uses the same routines as the kernel
>> base KASLR. The issue is with older x86 systems, which continue to be
>> very common.
>
> We have the same issue in embedded. :-(  Compounded by the fact that
> there is no rand instruction (at least not on ARM).  So, even if there's
> a HW-RNG, you can't access it until the driver is loaded.
>
> This is compounded by the fact that most systems deployed today have
> bootloaders a) without hw-rng drivers, b) without dtb editing, and c)
> without dtb support at all.
>
> My current thinking is to add a devicetree property
> "userspace,random-seed" <address, len>.  This way, existing, deployed
> boards can append a dtb to a modern kernel with the property set.
> The factory bootloader then only needs to amend its boot scripts to read
> random-seed from the fs to the given address.

The arm64 KASLR implementation has defined a way for boot loaders to
pass in an seed similar to this. It might be nice to have a fall-back
to a DT entry, though, then the bootloaders don't need to changed.

Ard might have some thoughts on why DT wasn't used for KASLR (I assume
the early parsing overhead, but I don't remember the discussion any
more).

> Modern systems that receive a seed from the bootloader via the
> random-seed property (typically from the hw-rng) can mix both sources
> for increased resilience.

Yeah, that could work.

> Unfortunately, I'm not very familiar with the internals of x86
> bootstrapping.  Could GRUB be scripted to do a similar task?  How would
> the address and size of the seed be passed to the kernel?  command line?

Command line could work (though it would need scrubbing to avoid it
leaking into /proc/cmdine), but there's also the "zero-page" used by
bootloaders to pass details to the kernel (see
Documentation/x86/boot.txt). Right now, x86 has sufficient entropy
(though rdrand is best).

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
