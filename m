MIME-Version: 1.0
References: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
 <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
 <CAOfkYf4G_zV9v+GT4i=W+Zkkq32oPKFXH3E8kmMuDVS84r+AAQ@mail.gmail.com>
 <CAGXu5jJJbnhUMovTaG_U=vJijEWuWkM1dMoh6Mm4gUmN4Ua_Dg@mail.gmail.com>
 <CAOfkYf4SiLvReac4H0-w1nZLwXQqZD8xAbN_dffzppcmH3S2Gg@mail.gmail.com>
 <CAGXu5jLSLFNypH-JxmdWXKXawC74oTjzzfX_Qn5Gix2oNawQSA@mail.gmail.com>
 <CAOfkYf4O7QROpwpyQ7Pyoe7+TtOQFzQhF5b3uhvSd2xDTYVGJg@mail.gmail.com> <CAGXu5jJ9_mNhsZr_ozj3P_BAYcy9LHbHZeDbPMX_rBmX-9uQ-g@mail.gmail.com>
In-Reply-To: <CAGXu5jJ9_mNhsZr_ozj3P_BAYcy9LHbHZeDbPMX_rBmX-9uQ-g@mail.gmail.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 20 Apr 2019 16:17:13 +0530
Message-ID: <CAOfkYf6T_h57VLYccqqfprP2ykg0e0rGt2V8LTRMpF21dn2_Hg@mail.gmail.com>
Subject: Re: willing to involve in KSPP
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

>
> On Wed, Apr 17, 2019 at 9:22 AM Shyam Saini <mayhs11saini@gmail.com> wrote:
> >
> >
> > > On Mon, Apr 15, 2019 at 10:44 PM Shyam Saini <mayhs11saini@gmail.com> wrote:
> > > > As you may already know that I've submitted the patch as per your
> > > > suggestion but I'm still not
> > >
> > > Thanks, i saw that! I'm hoping akpm will take it.
> >
> > Would you please acknowledge these patches ?
>
> Other folks had questions about them -- I was assuming you would

yes, I'll respond to the thread. Sorry for the delay.

> answer those questions, etc. It sounded like people wanted to see the
> series reduced to a single patch to do everything at once, so a v2
> might be a good idea.

There is one suggestion to  retain sizeof_field as alias of FIELD_SIZEOF
for the code compatibility reason.

Seems like it created confusion because of two separate patches.
Anyway, I'll post one single patch

> > Could you please suggest me series of more tasks so that I don't have to bother you
> > each and every time for new task. :-)
>
> Sure! Here are two:
> - WARN on kfree() of ERR_PTR range
> (or ignore them, as if it were NULL)
>
> Right now kfree() only checks for NULL and zero sized allocations.
> It'd be nice if it would WARN() (and skip) freeing the ERR_PTR range
> (the -1 through -4095 addresses). The clever thing grsecurity did was
> redefine the ZERO_SIZE allocation pointer to be -4096, and update the
> ZERO_OR_NULL_PTR check[1]:
>
> -#define ZERO_SIZE_PTR ((void *)16)
> +#define ZERO_SIZE_PTR              \
> +({                     \
> +   BUILD_BUG_ON(!(MAX_ERRNO & ~PAGE_MASK));\
> +   (void *)(-MAX_ERRNO-1L);        \
> +})
>
> -#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
> -               (unsigned long)ZERO_SIZE_PTR)
> +#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) - 1 >= (unsigned
> long)ZERO_SIZE_PTR - 1)
>
> So while the change is small (and be sure to give them credit[2]), it
> might take some convincing various memory allocation folks that this
> change makes sense. (I like it because it moves the ZERO_SIZE_PTR out
> of userspace -- technically it was still in the NULL page, but better
> to collect it up in unmapped memory at the top of the address space.)
> This change should make a bunch of bugs around mishandling of ERR_PTRs
> stand out better. People I would Cc:
>
> Matthew Wilcox <willy@infradead.org>
> Christoph Lameter <cl@linux.com>
>
>
> Another one that needs some checking is:
>
> - audit and fix all misuse of NLA_STRING
>
> This is a following up on noticing the misuse of NLA_STRING (no NUL
> terminator), getting used with regular string functions (that expect a
> NUL termination):
> https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/#u
>
> It'd be nice if someone could inspect all the NLA_STRING
> representations and find if there are any other problems like this
> (and see if there was a good way to systemically fix the problem).
>
>
> -Kees
>
> [1] https://github.com/linux-scraping/linux-grsecurity/blame/grsec-test/include/linux/slab.h#L127
> [2] https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Get_Involved

Thanks for sharing these details. I'll proceed with this once
FIELD_SIZEOF clean up is done.
