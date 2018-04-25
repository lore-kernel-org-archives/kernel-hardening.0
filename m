MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180425111617.2f4dc127@canb.auug.org.au>
References: <20180422162345.004292133@linutronix.de> <20180422162512.363154748@linutronix.de>
 <20180425111617.2f4dc127@canb.auug.org.au>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Apr 2018 19:45:42 -0700
Message-ID: <CAGXu5jLUgNGW-SXY3L2fJrBV3PpmAH9uXFV87xmPe14BrYnWMw@mail.gmail.com>
Subject: Re: [patch V3 01/10] rslib: Add GFP aware init function
Content-Type: text/plain; charset="UTF-8"
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Neil Brown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 24, 2018 at 6:16 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Thomas,
>
> On Sun, 22 Apr 2018 18:23:46 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> The rslib usage in dm/verity_fec is broken because init_rs() can nest in
>> GFP_NOIO mempool allocations as init_rs() is invoked from the mempool alloc
>> callback.
>>
>> Provide a variant which takes gfp_t flags as argument.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: Neil Brown <neilb@suse.com>
>> ---
>>  include/linux/rslib.h           |   26 +++++++++++++++++++++++---
>>  lib/reed_solomon/reed_solomon.c |   36 ++++++++++++++++++++----------------
>>  2 files changed, 43 insertions(+), 19 deletions(-)
>>
>> --- a/include/linux/rslib.h
>> +++ b/include/linux/rslib.h
>> @@ -77,10 +77,30 @@ int decode_rs16(struct rs_control *rs, u
>>  #endif
>>
>>  /* Create or get a matching rs control structure */
>> -struct rs_control *init_rs(int symsize, int gfpoly, int fcr, int prim,
>> -                        int nroots);
>> +struct rs_control *init_rs_gfp(int symsize, int gfpoly, int fcr, int prim,
>> +                            int nroots, gfp_t gfp);
>> +
>> +/**
>> + * init_rs - Create a RS control struct and initialize it
>> + *  @symsize:        the symbol size (number of bits)
>> + *  @gfpoly: the extended Galois field generator polynomial coefficients,
>> + *           with the 0th coefficient in the low order bit. The polynomial
>> + *           must be primitive;
>> + *  @fcr:    the first consecutive root of the rs code generator polynomial
>> + *           in index form
>> + *  @prim:   primitive element to generate polynomial roots
>> + *  @nroots: RS code generator polynomial degree (number of roots)
>> + *
>> + * Allocations use GFP_KERNEL.
>> + */
>> +static inline struct rs_control *init_rs(int symsize, int gfpoly, int fcr,
>> +                                      int prim, int nroots)
>> +{
>> +     return init_rs_gfp(symsize, gfpoly, fcr, prim, nroots, GFP_KERNEL);
>> +}
>> +
>
> The version of this patch that Kees has committed to his kspp tree in linux-next has
>
> #include <linux/slab.h>
>
> why not just
>
> #include <linux/types.h>        /* for gpf_t */
> #include <linux/gpf.h>          /* for GFP_KERNEL */
>
> ?

We could certainly switch to that. (Why doesn't gfp.h include types.h?)

-Kees


-- 
Kees Cook
Pixel Security
