MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKwvOdmCdgy8YiFwXj3Vg_hniiEgH6AMagm9XKC-SrydRazudg@mail.gmail.com>
References: <20180327203904.GA1151@beast> <CAKwvOdmCdgy8YiFwXj3Vg_hniiEgH6AMagm9XKC-SrydRazudg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Mar 2018 18:26:25 -0700
Message-ID: <CAGXu5j+O+P+tzgSpW7Uj90hZZPtW70KSNxfAHAJ5o0U0Kskt=Q@mail.gmail.com>
Subject: Re: [PATCH] exofs: Avoid VLA in structures
Content-Type: text/plain; charset="UTF-8"
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Boaz Harrosh <ooo@electrozaur.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 29, 2018 at 2:32 PM, Nick Desaulniers
<ndesaulniers@google.com> wrote:
> On Tue, Mar 27, 2018 at 1:39 PM Kees Cook <keescook@chromium.org> wrote:
>>[...]
>> +       if (numdevs > (INT_MAX - sizeof(*ios)) /
>> +                      sizeof(struct ore_per_dev_state))
>> +               return -ENOMEM;
>> +       size_ios = sizeof(*ios) + sizeof(struct ore_per_dev_state) *
> numdevs;
>
> Can all these invariant checks that return -ENOMEM be grouped together, as
> it seems we have ...
>
>> +
>> +       if (sgs_per_dev * numdevs > INT_MAX / sizeof(struct osd_sg_entry))
>> +               return -ENOMEM;
>> +       if (num_par_pages > INT_MAX / sizeof(struct page *))
>> +               return -ENOMEM;
>
> ...a whole bunch of single conditions with the same body, can be combined
> with one:
>
> if (a)
>    return d;
> if (b)
>    return d;
> if (c)
>    return d;
>
> ->
>
> if (a || b || c)
>    return d;

I find that harder to read, so I let the compiler do the grouping for
me. As each "if" maps to a portion of the assignment that follows it,
I like it how it is. If there's agreement that they should be grouped,
that's fine by me, of course. :)

>> +       size_extra = max(sizeof(struct osd_sg_entry) * (sgs_per_dev *
> numdevs),
>
> Do you need parens around the sub-expression `(sgs_per_dev * numdevs)`?

No, max() correctly protects those.

>> diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
>> index 27cbdb697649..659129d5e9f7 100644
>> --- a/fs/exofs/ore_raid.c
>> +++ b/fs/exofs/ore_raid.c
>> @@ -71,6 +71,11 @@ static int _sp2d_alloc(unsigned pages_in_unit,
> unsigned group_width,
>>   {
>>          struct __stripe_pages_2d *sp2d;
>>          unsigned data_devs = group_width - parity;
>> +
>> +       /*
>> +        * Desired allocation layout is, though when larger than
> PAGE_SIZE,
>> +        * each struct __alloc_1p_arrays is separately allocated:
>> +
>>          struct _alloc_all_bytes {
>>                  struct __alloc_stripe_pages_2d {
>>                          struct __stripe_pages_2d sp2d;
>> @@ -82,55 +87,85 @@ static int _sp2d_alloc(unsigned pages_in_unit,
> unsigned group_width,
>>                          char page_is_read[data_devs];
>>                  } __a1pa[pages_in_unit];
>>          } *_aab;
>> +
>>          struct __alloc_1p_arrays *__a1pa;
>>          struct __alloc_1p_arrays *__a1pa_end;
>> -       const unsigned sizeof__a1pa = sizeof(_aab->__a1pa[0]);
>> +
>> +       */
>> +
>> +       char *__a1pa;
>> +       char *__a1pa_end;
>> +
>
> Just my notes, since this block could use another eye for review:

Tell me about it. :P These could may be named better, but I'm not
familiar with the naming conventions of this code...

>
>> +       const size_t sizeof_stripe_pages_2d =
>> +               sizeof(struct __stripe_pages_2d) +
>> +               sizeof(struct __1_page_stripe) * pages_in_unit;
>
> Ok, so this replaces sizeof(_aab->__asp2d).
>
>> +       const size_t sizeof__a1pa =
>> +               ALIGN(sizeof(struct page *) * (2 * group_width) +
> data_devs,
>> +                     sizeof(void *));
>
> And this replaces sizeof(_aab->__a1pa[0]);
>
>> +       const size_t sizeof__a1pa_arrays = sizeof__a1pa * pages_in_unit;
>
> This replaces sizeof(_aab->__a1pa[pages_in_unit]);

Technically what you've written is still a single element of the array
(same as _aab->__a1pa[0] above). This replaces sizeof(_aab->__a1pa)
(the entire array size in bytes).

>
>> +       const size_t alloc_total = sizeof_stripe_pages_2d +
>> +                                  sizeof__a1pa_arrays;
>
> Replaces sizeof(*_aab);
>
> This is the trickiest part of this patch IMO, I think it needs careful
> review, but looks correct to me.

Thanks! That's why I added a bunch of comments. It was not obvious to
me what was happening.

>> -               sp2d->_1p_stripes[i].pages = __a1pa->pages;
>> -               sp2d->_1p_stripes[i].scribble = __a1pa->scribble ;
>> -               sp2d->_1p_stripes[i].page_is_read = __a1pa->page_is_read;
>> -               ++__a1pa;
>> +               /*
>> +                * Attach all _lp_stripes pointers to the allocation for
>> +                * it which was either part of the original PAGE_SIZE
>> +                * allocation or the subsequent allocation in this loop.
>> +                */
>> +               sp2d->_1p_stripes[i].pages = (void *)__a1pa;
>> +               sp2d->_1p_stripes[i].scribble =
>> +                       sp2d->_1p_stripes[i].pages + group_width;
>> +               sp2d->_1p_stripes[i].page_is_read =
>> +                       (char *)(sp2d->_1p_stripes[i].scribble +
> group_width);
>
> Can you DRY up `sp2d->_1p_stripes[i]`? ex.
>
> struct _1p_stripes* stripe;
>
> for (i = 0; i < pages_in_unit; ...
>    ...
>    stripe = &sp2d->_1p_stripes[i];
>    stripe->pages = (void*)__a1pa;
>    stripe->scribble = stripe->pages + group_width;
>    stripe->page_is_read = (char*)stripe->scribble + group_width;

Yeah, that could make it more readable.

>
>> +               __a1pa += sizeof__a1pa;
>>          }
>
>>          sp2d->parity = parity;
>> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
>> index 179cd5c2f52a..f3c29e9326f1 100644
>> --- a/fs/exofs/super.c
>> +++ b/fs/exofs/super.c
>> @@ -549,27 +549,26 @@ static int exofs_devs_2_odi(struct
> exofs_dt_device_info *dt_dev,
>>   static int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
>>                        struct exofs_dev **peds)
>>   {
>> -       struct __alloc_ore_devs_and_exofs_devs {
>> -               /* Twice bigger table: See exofs_init_comps() and comment
> at
>> -                * exofs_read_lookup_dev_table()
>> -                */
>> -               struct ore_dev *oreds[numdevs * 2 - 1];
>> -               struct exofs_dev eds[numdevs];
>> -       } *aoded;
>> +       /* Twice bigger table: See exofs_init_comps() and comment at
>> +        * exofs_read_lookup_dev_table()
>> +        */
>> +       size_t numores = numdevs * 2 - 1;
>
> const size_t

Good call.

> The sizeof calculations replacing the VLAIS I pointed out are pretty tricky
> to follow, but I feel pretty confident about this patch.  With the changes
> I recommend, feel free to add my Reviewed-by tag.  It would be good to get
> additional review and testing from the maintainer.

Yes, agreed. I'll send a v2 with your suggestions.

> Thanks for taking the time to tackle this.

Thanks for the review!

-Kees

-- 
Kees Cook
Pixel Security
