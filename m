MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
 <20180218221352.GA6651@ravnborg.org> <CAFkk2KT1krKuDkWt0eHcasfC61fTVQNf-1kqw7icLP9OYGYkXQ@mail.gmail.com>
 <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com>
 <CAK8P3a2BOQt5Y0B4271WqaJvvWqfxHxD3S6r1i1xONvb+CJ5Dg@mail.gmail.com>
 <CAK7LNARtZcW1v53ridFJK1MULmj8tQT4s+DoRhKj9PrbMri5rQ@mail.gmail.com>
 <CAK8P3a1DrhxWXaEs6E85W5HEhvFr23E-GDsu=0X-sG0pX+PLag@mail.gmail.com> <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 21 Feb 2018 17:03:25 +0100
Message-ID: <CAK8P3a3-eufj=HM4Mi+KaSLxuoPwtw0P4EfmtYfVcbnR0mVwAw@mail.gmail.com>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rich Felker <dalias@libc.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>, Linux-sh list <linux-sh@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Jeff Dike <jdike@addtoit.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, user-mode-linux-user@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, Ulf Magnusson <ulfalizer@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 1:57 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> 2018-02-21 19:52 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
>> On Wed, Feb 21, 2018 at 11:20 AM, Masahiro Yamada
>> <yamada.masahiro@socionext.com> wrote:
>>> 2018-02-21 18:56 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
>>>> On Wed, Feb 21, 2018 at 8:38 AM, Masahiro Yamada
>>>> <yamada.masahiro@socionext.com> wrote:
>>>>> 2018-02-20 0:18 GMT+09:00 Ulf Magnusson <ulfalizer@gmail.com>:
>
> Hmm, I think I can implement those somehow.
> But, I hope we do not have many instances like this...
>
>
> If you know more naive cases, please share your knowledge.
>

One case that comes to mind would be architecture level selection on 32-bit
ARM, which is roughly this (I probably have some details wrong, but you
get the idea):

- older compilers don't support the latest architecture setting (-march=armv8
  or -march=armv7ve)
- newer compilers no longer support really old architectures (-march=armv4)
- setting -mthumb requires setting one of  -march=armv7-a, armv7ve, armv7-m or
  armv8 if the compiler doesn't default to those
- on a compiler that defaults to -marm, setting -march=armv7-m requires
  setting -mthumb (IIRC)
- really old compilers only support OABI, but not EABI
- newer compilers no longer support OABI
- mthumb requires EABI
- armv6 and higher are subtly broken with OABI, but only when using
  certain inline assembly with 64-bit arguments in register pairs.

I think we just shouldn't try to capture all of the above correctly in Kconfig
conditionals.

       Arnd
