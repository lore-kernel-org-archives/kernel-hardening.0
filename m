MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1530771852-21998-1-git-send-email-yamada.masahiro@socionext.com>
References: <1530771852-21998-1-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Jul 2018 17:16:34 -0700
Message-ID: <CAGXu5jK3jgJ5qvT4jPKgvO_Jf+edeLRYKrJ+67r7zrVszB2_xw@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: split out Kconfig entries to scripts/gcc-plugins/Kconfig
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Josef Bacik <jbacik@fb.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 4, 2018 at 11:24 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> Collect relevant code into the scripts/gcc-plugins directory.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
>  arch/Kconfig                | 146 +-------------------------------------------
>  scripts/gcc-plugins/Kconfig | 141 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 143 insertions(+), 144 deletions(-)
>  create mode 100644 scripts/gcc-plugins/Kconfig

I'd been pondering this for a while too. Thanks for sending the patch,
I'll include it in my gcc-plugins tree.

-Kees

-- 
Kees Cook
Pixel Security
