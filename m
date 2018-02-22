From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
In-Reply-To: <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com> <20180218221352.GA6651@ravnborg.org> <CAFkk2KT1krKuDkWt0eHcasfC61fTVQNf-1kqw7icLP9OYGYkXQ@mail.gmail.com> <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com> <CAK8P3a2BOQt5Y0B4271WqaJvvWqfxHxD3S6r1i1xONvb+CJ5Dg@mail.gmail.com> <CAK7LNARtZcW1v53ridFJK1MULmj8tQT4s+DoRhKj9PrbMri5rQ@mail.gmail.com> <CAK8P3a1DrhxWXaEs6E85W5HEhvFr23E-GDsu=0X-sG0pX+PLag@mail.gmail.com> <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
Date: Thu, 22 Feb 2018 14:22:02 +1100
Message-ID: <87efldr9np.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
To: Masahiro Yamada <yamada.masahiro@socionext.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@libc.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>, Linux-sh list <linux-sh@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Jeff Dike <jdike@addtoit.com>, user-mode-linux-user@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, Ulf Magnusson <ulfalizer@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Masahiro Yamada <yamada.masahiro@socionext.com> writes:
>
<snip>
>
> (Case 3)
> Compiler flag -foo is sensitive to endian-ness.
>
>
> config CC_NEEDS_BIG_ENDIAN
>           def_bool $(cc-option -mbig-endian) && CPU_BIG_ENDIAN
>
> config CC_NEEDS_LITTLE_ENDIAN
>           def_bool $(cc-option -mlittle-endian) && CPU_LITTLE_ENDIAN
>
> config CC_HAS_FOO
>          bool
>          default $(cc-option -mbig-endian -foo) if CC_NEEDS_BIG_ENDIAN
>          default $(cc-option -mlittle-endian -foo) if CC_NEEDS_LITTLE_ENDIAN
>          default $(cc-option -foo)

We may do something like this on powerpc, where we have 32/64-bit and
big/little endian (on 64-bit) and then some ABI options that we
set/unset depending on endian.

The above looks like it could work though.

cheers
