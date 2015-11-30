Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151130222437.GT8644@n2100.arm.linux.org.uk>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
	<1448494286-16029-2-git-send-email-keescook@chromium.org>
	<20151126075130.GB18742@gmail.com>
	<CAGXu5j+Mom2oYbsSE65BMCAgio68J6ST4wODUf8-qHdxOe0jOQ@mail.gmail.com>
	<20151130222437.GT8644@n2100.arm.linux.org.uk>
Date: Mon, 30 Nov 2015 14:34:04 -0800
Message-ID: <CAGXu5jJu3oRGRTUQzSpJ0SyZFQdX6UoERE-F6A9==jzAdRnQwA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] init: create cmdline param to disable readonly
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Catalin Marinas <catalin.marinas@arm.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 30, 2015 at 2:24 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 30, 2015 at 01:52:10PM -0800, Kees Cook wrote:
>> On Wed, Nov 25, 2015 at 11:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> > * Kees Cook <keescook@chromium.org> wrote:
>> >> +#ifdef CONFIG_DEBUG_RODATA
>> >
>> > Btw., could you please remove the Kconfig option altogether in an additional patch
>> > and make read-only sections an always-on feature? It has been default-y for years
>> > and all distros have it enabled.
>>
>> Yeah, this is something I've wanted to do for a while, but I would
>> point out that only a few architectures have actually implemented it,
>> and for arm and arm64 it was very recent:
>
> I don't think it can entirely be a kernel command line option.  On ARM,
> enabling DEBUG_RODATA has a substantial effect on the size of the kernel
> image - we have to pad various sections to 1MB boundaries so we can
> set the appropriate permissions.
>
> Forcing this layout on everyone won't work.
>
> What we can do is the half-way house: we can have the kernel command
> line option which enables and disables the protections, but the layout
> of the kernel image would still need to be controlled by DEBUG_RODATA.
> I'm left wondering what the advantage of that would be: it'd end up
> offering a suboptimal layout, additional memory usage but without the
> benefits of memory protections.

Right, I think it'll be there just as a debugging assist: something
broke with DEBUG_RODATA, let's boot with rodata=off and see what
happens.

> The alternative is keeping the kernel in unlinked object form, and
> laying out and linking the kernel at boot time, probably in PIC
> assembly code.  That's possible but I think is undesirable.
>
> So all in all, I'm in favour of keeping things as they are on ARM.

I've looked at the implementation in ARM again, and I think I see how
it can be improved slightly. I think I named things incorrectly when I
implemented, and I'll be sending a patch to fix that up. In the end,
though, I agree: the thing that is CONFIG_DEBUG_RODATA may change its
name, but on some architectures, there is a cost to using it, so it
needs to remain a CONFIG.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
