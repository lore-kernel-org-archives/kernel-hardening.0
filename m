Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161116151611.GD11228@leverpostej>
References: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
 <20161116151611.GD11228@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 17 Nov 2016 15:47:31 -0800
Message-ID: <CAGXu5jJ1LwLJ-f1Fx=Mu278-eeeqC+JakrH_WPT99PcHTXzbpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 16, 2016 at 7:16 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Nov 16, 2016 at 10:39:38PM +0800, Gengjia Chen wrote:
>>    Patch 1 introduce the write-rarely memory section for
>>    those kernel objects which are read only mostly
>>    but need to be written to sometimes.
>>    Patch 2 introduce two helper functions (mark_wrdata_rw/
>>    mark_wrdata_ro) to make __write_rarely memory section
>>    writable or unwritable. They play like the pax_open_kernel/
>>    pax_close_kernel functions in grsecurity patch.Right now
>>    this only been implemented on arm32.

Thanks Gengjia for working on this!

As part of this, can you add some lkdtm (drivers/misc/lkdtm*.c) tests
for these kinds of memory sections, so it's possible to test the
feature? And as other have mentioned, finding some simple examples of
where to use this primitive would be great. I think I saw a small one
in grsecurity in drivers/cdrom/cdrom.c where cdo->generic_packet gets
assigned. It's the only thing updated in the entire cdo object:

-       if (!cdo->generic_packet)
-               cdo->generic_packet = cdrom_dummy_generic_packet;
+       if (!cdo->generic_packet) {
+               pax_open_kernel();
+               const_cast(cdo->generic_packet) = cdrom_dummy_generic_packet;
+               pax_close_kernel();
+       }

> I've mentioned this elsewhere, but I don't think {open,close}_kernel()
> works as an interface. Specifically, I don't believe it can be safely
> and efficiently implemented for arm with LPAE, nor arm64.

I've seen similar objections from x86 maintainers.

> To cater for those it may be possible to use a temporary RW mapping
> separate from the usual kernel mapping (e.g. in TTBR0 on arm64). It
> should be possible to have an API that can use either approach, if
> writers are suitable annotated.

Do you mean something besides a new fixmap?

As for annotation, this was something that came up during Kernel
Summit too. It'd be nice to have a type-checked function of some kind
that could be used. Maybe something like this (using the cdrom example
above):

   rare_write(cdo, generic_packet, cdrom_dummy_generic_packet);

> That all said, from the two patches it's not even clear how this would
> be used, as nothing is marked __write_rarely, nor are any writers
> updated. A demonstration would be helpful.

The primary user of this would be the constify plugin, which marks all
structures that contain only function pointers as being read-only. It
also takes annotations for other things that are found manually.

> It would also be worth getting these onto the relevant lists (per
> scripts/get_maintainer.pl), so as to get the relevant core and
> architecture maintainers involved as early as possible.

Yeah, once some more examples are seen, it should be clear how to best
build the API.

-Kees

-- 
Kees Cook
Nexus Security
