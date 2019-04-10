MIME-Version: 1.0
References: <20190410131726.250295-1-glider@google.com> <20190410131726.250295-3-glider@google.com>
In-Reply-To: <20190410131726.250295-3-glider@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 10 Apr 2019 09:09:35 -0700
Message-ID: <CAGXu5jJt3uNWVXDD=GR6oVwn=g7O=Jcz9sxai5q10X9yyR56XA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
To: Alexander Potapenko <glider@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 6:18 AM Alexander Potapenko <glider@google.com> wrote:
>
> This config option adds the possibility to initialize newly allocated
> pages and heap objects with a 0xAA pattern.
> There's already a number of places where allocations are initialized
> based on the presence of __GFP_ZERO flag. We just change this code so
> that under CONFIG_INIT_ALL_HEAP these allocations are always initialized
> with either 0x00 or 0xAA depending on the __GFP_ZERO.

Why not just make __GFP_ZERO unconditional instead? This looks like
it'd be simpler and not need arch-specific implementation?

-- 
Kees Cook
