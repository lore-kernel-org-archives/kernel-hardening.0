MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.21.1803091610120.1364@nanos.tec.linutronix.de>
References: <20180309144613.GA48965@beast> <alpine.DEB.2.21.1803091610120.1364@nanos.tec.linutronix.de>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 9 Mar 2018 12:57:51 -0800
Message-ID: <CAGXu5j+hySkn5dHpKeRAf8NBm6p+iWDG+eVqs_HGDmu2naTdTw@mail.gmail.com>
Subject: Re: [PATCH][RFC] rslib: Remove VLAs by setting upper bound on nroots
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 7:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 9 Mar 2018, Kees Cook wrote:
>
>> Avoid VLAs[1] by always allocating the upper bound of stack space
>> needed. The existing users of rslib appear to max out at 32 roots,
>> so use that as the upper bound.
>
> I think 32 is plenty. Do we have actually a user with 32?

I found 24 as the max, but thought maybe 32 would be better?

drivers/md/dm-verity-fec.h:#define DM_VERITY_FEC_RSM            255
drivers/md/dm-verity-fec.h:#define DM_VERITY_FEC_MAX_RSN                253
drivers/md/dm-verity-fec.h:#define DM_VERITY_FEC_MIN_RSN
 231     /* ~10% space overhead */
drivers/md/dm-verity-fec.c:

                if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1
|| !num_c ||
                    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
                    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
                        ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
                        return -EINVAL;
                }
                v->fec->roots = num_c;
...
drivers/md/dm-verity-fec.c:     return init_rs(8, 0x11d, 0, 1, v->fec->roots);

So this can be as much as 24.

drivers/mtd/nand/diskonchip.c:#define NROOTS 4
drivers/mtd/nand/diskonchip.c:  rs_decoder = init_rs(10, 0x409, FCR, 1, NROOTS);

4.

fs/pstore/ram.c:static int ramoops_ecc;
fs/pstore/ram.c:module_param_named(ecc, ramoops_ecc, int, 0600);
fs/pstore/ram.c:MODULE_PARM_DESC(ramoops_ecc,
fs/pstore/ram.c:        dummy_data->ecc_info.ecc_size = ramoops_ecc ==
1 ? 16 : ramoops_ecc;
...
fs/pstore/ram.c:        cxt->ecc_info = pdata->ecc_info;
...
fs/pstore/ram_core.c:   prz->rs_decoder =
init_rs(prz->ecc_info.symsize, prz->ecc_info.poly,
fs/pstore/ram_core.c-                             0, 1, prz->ecc_info.ecc_size);

The default "ecc enabled" mode for pstore is 16, but was made dynamic
a while ago. However, I've only ever seen people use a smaller number
of roots.

>> Alternative: make init_rs() a true caller-instance and pre-allocate
>> the workspaces. Will this need locking or are the callers already
>> single-threaded in their use of librs?
>
> init_rs() is an init function which needs to be invoked _before_ the
> decoder/encoder can be used.
>
> The way it works today that it can share the rs_control between users to
> avoid duplicating the polynom arrays and the setup of them.
>
> So we might change how rs_control works and allocate rs_control for each
> invocation of init_rs(). That means we need two data structures:
>
> Rename rs_control to rs_poly and just use that internaly for sharing the
> polynom arrays.
>
> rs_control then becomes:
>
> struct rs_control {
>         struct rs_poly  *poly;
>         uint16_t        lamda[MAX_ROOTS + 1];
>         ....
>         uint16_t        loc[MAX_ROOTS];
> };
>
> But as you said that requires serialization or separation at the usage
> sites.

Right. Not my favorite idea. :P

> drivers/mtd/nand/* would either need a mutex or allocate one rs_control per
> instance. Simple enough to do.
>
> drivers/md/dm-verity-fec.c looks like it's allocating a dm control struct
> for each worker thread, so that should just require allocating one
> rs_control per worker then.
>
> pstore only has an issue in case of OOPS. A simple solution would be to
> allocate two rs_control structs, one for regular usage and one for the OOPS
> case. Not sure if that covers all possible problems, so that needs more
> thoughts.

Maybe I should just go with 24 as the max, and if we have a case where
we need more, address it then?

-Kees

-- 
Kees Cook
Pixel Security
