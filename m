MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com>
References: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 2 Mar 2017 20:02:57 -0800
Message-ID: <CAGXu5jKwDdwrdZ8z90e4Q5Xv4KeHjBoVtb7btxPGfmHpdaEwMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] arm64: support HAVE_ARCH_RARE_WRITE
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, PaX Team <pageexec@freemail.hu>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 2, 2017 at 7:00 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>  This RFC is a quick and dirty arm64 implementation for Kees Cook's RFC for
> rare_write infrastructure [1].

Awesome! :)

>  This implementation is based on Mark Rutland's suggestions, which is that
> a special userspace mm that maps only __start/end_rodata as RW permission
> is prepared during early boot time (paging_init) and __arch_rare_write_map()
> switches to the mm [2].
>
>  Due to the limit of implementation (the mm having RW mapping is userspace
> mm), we need a new arch-specific __arch_rare_write_ptr() to convert RO
> address to RW address (CONFIG_HAVE_RARE_WRITE_PTR is added), which is
> general for all architectures (__rare_write_ptr()) in Kees's RFC . So all
> writes should be instrumented by __rare_write().

Cool, yeah, I'll get all this fixed up in my next version.

>  One caveat for arm64 is CONFIG_ARM64_SW_TTBR0_PAN.
> Because __arch_rare_write_map() installes a special user mm to ttbr0,
> usercopy inside  __arch_rare_write_map/unmap() pair will break rare_write.
> (uaccess_enable() replaces the special mm and RW alias is no longer valid.)

That's totally fine constraint: this case should never happen for so
many reasons. :)

>  A similar problem could rise in general usercopy inside
> __arch_rare_write_map/unmap(). __arch_rare_write_map() replaces current->mm,
> so we loose the address space of the `current` process.
>
> It passes LKDTM's rare write test.
>
> [1] : http://www.openwall.com/lists/kernel-hardening/2017/02/27/5
> [2] : https://lkml.org/lkml/2017/2/22/254
>
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>

-Kees

-- 
Kees Cook
Pixel Security
