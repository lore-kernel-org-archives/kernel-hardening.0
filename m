MIME-Version: 1.0
References: <20190423194925.32151-1-keescook@chromium.org> <20190423194925.32151-3-keescook@chromium.org>
 <84ed0a4b-b1e5-ae86-56c1-40a212734667@linux.com>
In-Reply-To: <84ed0a4b-b1e5-ae86-56c1-40a212734667@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 24 Apr 2019 14:02:02 -0700
Message-ID: <CAGXu5jKkv2EvxZEO_V_0djDhaW-+WToZ2D477_PRnnMfAFDpTA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] security: Move stackleak config to Kconfig.hardening
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 24, 2019 at 8:25 AM Alexander Popov <alex.popov@linux.com> wrote:
>
> On 23.04.2019 22:49, Kees Cook wrote:
> > This moves the stackleak plugin options to Kconfig.hardening's memory
> > initialization menu.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Hello Kees,
>
> I see the changes in STACKLEAK help, looks good to me.
> For this patch -
>   Reviewed-by: Alexander Popov <alex.popov@linux.com>

Thanks!

> By the way, for your information, GCC_PLUGIN_STRUCTLEAK help is now unreachable
> from 'make menuconfig'.

Good point. I'll see if I can find a sensible place to move this to.
There isn't really a place for just the plugin details any more...
hmm.

-- 
Kees Cook
