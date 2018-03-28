MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1522128575-5326-18-git-send-email-yamada.masahiro@socionext.com>
References: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com> <1522128575-5326-18-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Mar 2018 04:29:26 -0700
Message-ID: <CAGXu5j+mJeG+POhgPkoanX8SVnY0LvTDoBUsyTNGpKh0KYiHMQ@mail.gmail.com>
Subject: Re: [PATCH v2 17/21] gcc-plugins: always build plugins with C++
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Ulf Magnusson <ulfalizer@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Nicolas Pitre <nico@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 10:29 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> If the target compiler is GCC 4.8 or newer, plugins are compiled with
> HOSTCXX.  Otherwise, gcc-plugin.sh will select HOSTCC or HOSTCXX.
>
> To simplify things, drop the HOSTCC support for plugins.  If you use
> GCC plugins, the requirement for the target compiler is GCC 4.8 (or
> older compiler with necessary features backported).  This is a feature
> for advanced users, so this requirement would not be a big deal.
> Currently, building plugins requires GCC 4.5, so this is not a big jump.

Emese already NAKed this, and I'd agree. 4.5 to 4.8 is quite a jump
(see all the threads on minimum gcc versions). Until we're at 4.8 as a
minimum, let's leave this as-is. "To simply things" doesn't seem like
a good enough reason to me.

-Kees

-- 
Kees Cook
Pixel Security
