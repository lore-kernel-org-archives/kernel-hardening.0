MIME-Version: 1.0
In-Reply-To: <CAGXu5jLRyDQ9M209JyNQRm3M+4ZtzdE9W0=7S7aXqSMavFZi1A@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460> <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
 <CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
 <CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com>
 <20170215125735.17920d58@kaiwan-T460> <CAGXu5jLRyDQ9M209JyNQRm3M+4ZtzdE9W0=7S7aXqSMavFZi1A@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Fri, 17 Feb 2017 08:48:52 +0530
Message-ID: <CAPDLWs_aEURmQ2Drz_AWsPXC-Xi2Q36HG4p-ZTVmx5+ZX4bdHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

>
> Hm, we don't want to force this on against other command line
> settings, so how about what I suggest below...
>

Ok, can see the logic in that..

>
> Can this be changed to interact better with the command line
> arguments, in case someone selects CONFIG_MEMORY_SANITIZE, but boots
> with page_poison=off?
>
> e.g. instead of your init code, do this:
>
> static bool want_page_poisoning __read_mostly =
> IS_ENABLED(CONFIG_MEMORY_SANITIZE);
>
> That way the logic for __page_poisoning_enabled is retained, etc.
>
>> +
>>  static inline void set_page_poison(struct page *page)
>>  {
>>         struct page_ext *page_ext;
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d24e1ce..62de543 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -457,6 +457,17 @@ static int slub_debug;
>>  static char *slub_debug_slabs;
>>  static int disable_higher_order_debug;
>>
>> +static int __init memory_sanitize_slubdebug_init(void)
>> +{
>> +/* With 'memory sanitize' On, slub_debug Must be set to 'p' */
>> +       if (IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
>> +            IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
>> +               slub_debug |= SLAB_POISON;
>> +       }
>> +       return 0;
>> +}
>> +early_initcall(memory_sanitize_slubdebug_init);
>
> And instead of this, use:
>
> #if defined(CONFIG_SLUB_DEBUG_ON)
> # define SLUB_DEBUG_INITIAL_FLAGS       DEBUG_DEFAULT_FLAGS
> #elif defined(CONFIG_MEMORY_SANITIZE)
> # define SLUB_DEBUG_INITIAL_FLAGS       SLAB_POISON
> #else
> # define SLUB_DEBUG_INITIAL_FLAGS       0
> #endif
>
> static int slub_debug = SLUB_DEBUG_INITIAL_FLAGS;
>
> That way we're just setting the boot-time defaults and it'll safely
> interact with everything else.
>
> (I've added Christoph to CC to see what he thinks of this.)
>

What about a kernel command-line param - called 'mem_sanitize'?
If set to 'on', it will enforce the forced behaviour (as per the curr
implementation).

I can think of this (but...):
--------------------+--------------------------+---------------------------
mem_sanitize   |   page_poisoning   |    slub_debug
--------------------+--------------------------+---------------------------
      strict           |            on                |    |= SLAB_POISON
      normal       |                      <current default>
      off              |              off               |            off
--------------------+--------------------------+---------------------------

But... if you think about it, I guess only the "strict" option is useful in any
meaningful way.
'normal' is what we'll get when I re-implement the code
as you suggested above.
Do we even want an 'off' case? As again, we'd be poking into the page_poisoning
and slub_debug values.

Of course we can (and will) document all this...
Thoughts?

-Kaiwan.

> -Kees
>
> --
> Kees Cook
> Pixel Security
>
