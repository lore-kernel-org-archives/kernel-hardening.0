MIME-Version: 1.0
In-Reply-To: <20180222194541.35076c5b2166879a8d5d234a@gmail.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
 <1518806331-7101-21-git-send-email-yamada.masahiro@socionext.com> <20180222194541.35076c5b2166879a8d5d234a@gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 23 Feb 2018 21:37:53 +0900
Message-ID: <CAK7LNAT0EYibS3cSDtSxyXGmRp0PoctB4aWuFhPTZxnCuAd+2A@mail.gmail.com>
Subject: Re: [PATCH 20/23] gcc-plugins: always build plugins with C++
Content-Type: text/plain; charset="UTF-8"
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <michal.lkml@markovi.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-02-23 3:45 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> On Sat, 17 Feb 2018 03:38:48 +0900
> Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
>
>> If the target compiler is GCC 4.8 or newer, plugins are compiled with
>> HOSTCXX.  Otherwise, gcc-plugin.sh will select HOSTCC or HOSTCXX.
>>
>> To simpily things, let's decide GCC 4.8 is the requirement for GCC
>> pulgins.  With this, plugins are always built with HOSTCXX.  This is a
>> feature of advanced users, so this requirement whould not be not a big
>> issue.
>
> I disagree with such a decision. I think the gcc plugins should compile
> with older version because the kernel can be compiled with them too.
> The distros use these older versions as well and I can very well imagine
> that new plugins will extend these with backported features such as
> my sancov plugin.
>

Let me clarify this.

I removed the version check in the following patch:
https://patchwork.kernel.org/patch/10225379/

So, you can enable CONFIG_GCC_PLAUGINS
as long as scripts/gcc-plugin.sh passes
(i.e. C++ can compile plugins).

Even if it is unlikely happen,
GCC 4.5 -> 4.8 is not a big jump.

People were recently talking about the minimum compiler version
https://patchwork.kernel.org/patch/10207385/

The thread is super long, but my understanding was
4.5 or 4.6 would be reasonable.

So, we will be there sooner or later.


-- 
Best Regards
Masahiro Yamada
