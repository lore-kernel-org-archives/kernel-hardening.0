Date: Mon, 17 Jun 2019 22:07:41 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906172157.8E88196@keescook>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 17, 2019 at 03:10:27PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2019 17:10:49 +0200 Alexander Potapenko <glider@google.com> wrote:
> 
> > Slowdown for the new features compared to init_on_free=0,
> > init_on_alloc=0:
> > 
> > hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> > hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)
> 
> Sanity check time.  Is anyone really going to use this?  Seriously,
> honestly, for real?  If "yes" then how did we determine that?

Absolutely! This is expected to be on-by-default on Android and Chrome
OS. And it gives the opportunity for anyone else to use it under distros
too via the boot args. (The init_on_free feature is regularly requested
by folks where memory forensics is included in their thread models.)

As for the performance implications, the request during review was to
do that separately.

> Also, a bit of a nit: "init_on_alloc" and "init_on_free" aren't very
> well chosen names for the boot options - they could refer to any kernel
> object at all, really.  init_pages_on_alloc would be better?  I don't think
> this matters much - the boot options are already chaotic.  But still...

I agree; it's awkward. It covers both the page allocator and the slab
allocator, though, so naming it "page" seems not great. It's part of
a larger effort to auto-initialize all memory (stack auto-init has
been around in a few forms with the Clang support now in Linus's tree
for v5.2), and the feature has kind of ended up with the short name
of "meminit". As this is the "heap" side of "meminit", what about
"meminit.alloc=..." and "meminit.free=..." as alternative straw-men?

-- 
Kees Cook
