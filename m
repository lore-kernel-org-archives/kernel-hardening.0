MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
 <20180218221352.GA6651@ravnborg.org> <CAFkk2KT1krKuDkWt0eHcasfC61fTVQNf-1kqw7icLP9OYGYkXQ@mail.gmail.com>
 <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 21 Feb 2018 10:56:24 +0100
Message-ID: <CAK8P3a2BOQt5Y0B4271WqaJvvWqfxHxD3S6r1i1xONvb+CJ5Dg@mail.gmail.com>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ulf Magnusson <ulfalizer@gmail.com>, Rich Felker <dalias@libc.org>, Linux-sh list <linux-sh@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>, Yoshinori Sato <ysato@users.sourceforge.jp>, Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Jeff Dike <jdike@addtoit.com>, user-mode-linux-user@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 8:38 AM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> 2018-02-20 0:18 GMT+09:00 Ulf Magnusson <ulfalizer@gmail.com>:
>
>>>
>>> I'm not happy that we in one context can reference CONFIG variables
>>> directly, but inside the $(call ...) and $(shell ...) needs the $ prefix.
>>> But I could not come up with something un-ambigious where this could be avoided.
>>
>> I think we should be careful about allowing references to config
>> symbols. It mixes up the parsing and evaluation phases, since $() is
>> expanded during parsing (which I consider a feature and think is
>> needed to retain sanity).
>>
>> Patch 06/23 removes the last existing instance of symbol references in
>> strings by getting rid of 'option env'. That's an improvement to me.
>> We shouldn't add it back.
>
>
> This is really important design decision,
> so I'd like to hear a little more from experts.
>
>
> For example, x86 allows users to choose sub-arch, either 'i386' or 'x86_64'.
>
> https://github.com/torvalds/linux/blob/v4.16-rc2/arch/x86/Kconfig#L4
>
>
>
> If the user toggles CONFIG_64BIT,
> the bi-arch compiler will work in a slightly different mode
> (at least, back-end parts)
>
> So, my question is, is there a case,
>
> $(cc-option, -m32 -foo) is y, but
> $(cc-option, -m64 -foo) is n  ?
> (or vice versa)
>
>
> If the answer is yes, $(cc-option -foo) would have to be re-calculated
> every time CONFIG_64BIT is toggled.
>
> This is what I'd like to avoid, though.

The -m32/-m64 trick (and -mbig-endian/-mlittle-endian on other architectures
as well as a couple of other flags) only works if the compiler is configured to
support it. In other cases (e.g. big-endian xtensa), the kernel always
detects what the compiler does and silently configures itself to match
using Makefile logic.

On x86, compilers are usually built as bi-arch, but you can build one that
only allows one of them.

I can see two reasonable ways out:

- we don't use  $(cc-option -foo) in a case like this, and instead require the
  user to have a matching toolchain.
- we could make the 32/64 selection on x86 a 'choice' statement where
  each option depends on both the ARCH= variable and the
  $(cc-option, -m32)/ $(cc-option, -m64) output.

       Arnd
