Date: Fri, 17 May 2019 09:37:43 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
Message-ID: <201905170937.7A1E646F61@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-3-glider@google.com>
 <201905151752.2BD430A@keescook>
 <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 05:51:17PM +0200, Alexander Potapenko wrote:
> On Thu, May 16, 2019 at 3:02 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> > > Add tests for heap and pagealloc initialization.
> > > These can be used to check init_on_alloc and init_on_free implementations
> > > as well as other approaches to initialization.
> >
> > This is nice! Easy way to test the results. It might be helpful to show
> > here what to expect when loading this module:
>
> Do you want me to add the expected output to the patch description?

Yes, I think it's worth having, as a way to show people what to expect
when running the test, without having to actually enable, build, and
run it themselves.

-- 
Kees Cook
