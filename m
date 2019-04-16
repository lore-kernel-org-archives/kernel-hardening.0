MIME-Version: 1.0
References: <20190411180117.27704-1-keescook@chromium.org> <20190411180117.27704-2-keescook@chromium.org>
 <947dbe9a-3444-6fe4-9f79-f8f210da8960@linux.com>
In-Reply-To: <947dbe9a-3444-6fe4-9f79-f8f210da8960@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 15 Apr 2019 23:02:53 -0500
Message-ID: <CAGXu5jJTM=pdAjsC63Z6T=HaztTqSqUQQ8=GN=tqv2n6CKc3nw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] security: Create "kernel hardening" config area
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 15, 2019 at 11:44 AM Alexander Popov <alex.popov@linux.com> wrote:
>
> On 11.04.2019 21:01, Kees Cook wrote:
> > Right now kernel hardening options are scattered around various Kconfig
> > files. This can be a central place to collect these kinds of options
> > going forward. This is initially populated with the memory initialization
> > options from the gcc-plugins.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Hello Kees, hello everyone!
>
> After applying this series the kernel config looks like that:
>
> ...
> ...
> CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"
>
> #
> # Kernel hardening options
> #
>
> #
> # Memory initialization
> #
> CONFIG_INIT_STACK_NONE=y
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
> # CONFIG_GCC_PLUGIN_STACKLEAK is not set
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> ...
> ...
>
> What do you think about some separator between memory initialization options and
> CONFIG_CRYPTO?

This was true before too:

...
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y
...

Perhaps crypto/Kconfig's comment line could move to the top of the file?

comment "Crypto core or helper"

is what generates the separator...

-- 
Kees Cook
