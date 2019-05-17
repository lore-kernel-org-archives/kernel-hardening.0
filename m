Date: Fri, 17 May 2019 08:59:39 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 5/4] mm: Introduce SLAB_NO_FREE_INIT and mark excluded
 caches
Message-ID: <201905170858.CE4109E77@keescook>
References: <20190514143537.10435-5-glider@google.com>
 <201905161746.16E885F@keescook>
 <CAG_fn=W41zDac9DN9qVB_EwJG89f2cNBQYNyove4oO3dwe6d5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=W41zDac9DN9qVB_EwJG89f2cNBQYNyove4oO3dwe6d5Q@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 10:34:26AM +0200, Alexander Potapenko wrote:
> On Fri, May 17, 2019 at 2:50 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > In order to improve the init_on_free performance, some frequently
> > freed caches with less sensitive contents can be excluded from the
> > init_on_free behavior.
> Did you see any notable performance improvement with this patch?
> A similar one gave me only 1-2% on the parallel Linux build.

Yup, that's in the other thread. I saw similar. But 1-2% on a 5% hit is
a lot. ;)

-- 
Kees Cook
