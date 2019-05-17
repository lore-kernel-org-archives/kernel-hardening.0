Date: Fri, 17 May 2019 09:36:36 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905170928.A8F3BEC1B1@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
 <20190517140446.GA8846@dhcp22.suse.cz>
 <CAG_fn=W4k=mijnUpF98Hu6P8bFMHU81FHs4Swm+xv1k0wOGFFQ@mail.gmail.com>
 <20190517142048.GM6836@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517142048.GM6836@dhcp22.suse.cz>
To: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 04:20:48PM +0200, Michal Hocko wrote:
> On Fri 17-05-19 16:11:32, Alexander Potapenko wrote:
> > On Fri, May 17, 2019 at 4:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Tue 14-05-19 16:35:34, Alexander Potapenko wrote:
> > > > The new options are needed to prevent possible information leaks and
> > > > make control-flow bugs that depend on uninitialized values more
> > > > deterministic.
> > > >
> > > > init_on_alloc=1 makes the kernel initialize newly allocated pages and heap
> > > > objects with zeroes. Initialization is done at allocation time at the
> > > > places where checks for __GFP_ZERO are performed.
> > > >
> > > > init_on_free=1 makes the kernel initialize freed pages and heap objects
> > > > with zeroes upon their deletion. This helps to ensure sensitive data
> > > > doesn't leak via use-after-free accesses.
> > >
> > > Why do we need both? The later is more robust because even free memory
> > > cannot be sniffed and the overhead might be shifted from the allocation
> > > context (e.g. to RCU) but why cannot we stick to a single model?
> > init_on_free appears to be slower because of cache effects. It's
> > several % in the best case vs. <1% for init_on_alloc.
> 
> This doesn't really explain why we need both.

There are a couple reasons. The first is that once we have hardware with
memory tagging (e.g. arm64's MTE) we'll need both on_alloc and on_free
hooks to do change the tags. With MTE, zeroing comes for "free" with
tagging (though tagging is as slow as zeroing, so it's really the tagging
that is free...), so we'll need to re-use the init_on_free infrastructure.

The second reason is for very paranoid use-cases where in-memory
data lifetime is desired to be minimized. There are various arguments
for/against the realism of the associated threat models, but given that
we'll need the infrastructre for MTE anyway, and there are people who
want wipe-on-free behavior no matter what the performance cost, it seems
reasonable to include it in this series.

All that said, init_on_alloc looks desirable enough that distros will
likely build with it enabled by default (I hope), and the very paranoid
users will switch to (or additionally enable) init_on_free for their
systems.

-- 
Kees Cook
