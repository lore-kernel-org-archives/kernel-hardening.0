MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAK7LNASerehkH2391jHcXoqysiw-PWuxHsAgqHp+7vp04q+tYA@mail.gmail.com>
References: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com>
 <1522128575-5326-20-git-send-email-yamada.masahiro@socionext.com>
 <CAGXu5jJB3AKMC8U--H61eUkFJeMogLMq00dBUUrfg4n2b4FbOQ@mail.gmail.com> <CAK7LNASerehkH2391jHcXoqysiw-PWuxHsAgqHp+7vp04q+tYA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Apr 2018 09:09:02 -0700
Message-ID: <CAGXu5j+8OZ6cfQ9km1Y0Lgb3_vVCvgpqdacAPHDikvH_S=gnVQ@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] gcc-plugins: test GCC plugin support in Kconfig
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Ulf Magnusson <ulfalizer@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Nicolas Pitre <nico@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 11, 2018 at 8:55 AM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> No.
> There is no problem to use a compiler without plugin support.
>
> If a user does not want to use plugin in the first place,
> why does he/she need to be bothered by such information in stderr?

So, I don't think it's needed for the first version of this, but it'd
be nice to have a way for end users to discover _why_ some option they
want is unavailable. Having them dig through the Kconfigs, edit
scripts to see stderr again, running those by hand, etc, is really
unfriendly. If, instead, stderr was visible from the menuconfig "help"
for a Kconfig, it could serve as automatic documentation for why
something wasn't enabled. I don't mean for stderr to get sprayed out
during a regular "make"; I agree: that would be ugly and pointless.
I'd just like some way for the reason behind an option being disabled
to be discoverable in some way.

-Kees

-- 
Kees Cook
Pixel Security
