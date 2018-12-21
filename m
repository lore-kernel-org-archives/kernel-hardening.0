MIME-Version: 1.0
References: <20181219213338.26619-1-igor.stoppa@huawei.com>
 <20181219213338.26619-5-igor.stoppa@huawei.com> <20181220184917.GY10600@bombadil.infradead.org>
 <d5e8523a-3afd-d992-1af3-b329985c5ed5@gmail.com>
In-Reply-To: <d5e8523a-3afd-d992-1af3-b329985c5ed5@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 21 Dec 2018 09:23:03 -0800
Message-ID: <CALCETrU8GZbF2oWYeKUVKBURuh1zeMqcHM5RMTchiDsdrSSVPA@mail.gmail.com>
Subject: Re: [PATCH 04/12] __wr_after_init: x86_64: __wr_op
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Igor Stoppa <igor.stoppa@huawei.com>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 20, 2018 at 11:19 AM Igor Stoppa <igor.stoppa@gmail.com> wrote:
>
>
>
> On 20/12/2018 20:49, Matthew Wilcox wrote:
>
> > I think you're causing yourself more headaches by implementing this "op"
> > function.
>
> I probably misinterpreted the initial criticism on my first patchset,
> about duplication. Somehow, I'm still thinking to the endgame of having
> higher-level functions, like list management.
>
> > Here's some generic code:
>
> thank you, I have one question, below
>
> > void *wr_memcpy(void *dst, void *src, unsigned int len)
> > {
> >       wr_state_t wr_state;
> >       void *wr_poking_addr = __wr_addr(dst);
> >
> >       local_irq_disable();
> >       wr_enable(&wr_state);
> >       __wr_memcpy(wr_poking_addr, src, len);
>
> Is __wraddr() invoked inside wm_memcpy() instead of being invoked
> privately within __wr_memcpy() because the code is generic, or is there
> some other reason?
>
> >       wr_disable(&wr_state);
> >       local_irq_enable();
> >
> >       return dst;
> > }
> >
> > Now, x86 can define appropriate macros and functions to use the temporary_mm
> > functionality, and other architectures can do what makes sense to them.
> >

I suspect that most architectures will want to do this exactly like
x86, though, but sure, it could be restructured like this.

On x86, I *think* that __wr_memcpy() will want to special-case len ==
1, 2, 4, and (on 64-bit) 8 byte writes to keep them atomic. i'm
guessing this is the same on most or all architectures.

>
> --
> igor
