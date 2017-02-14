MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460> <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
 <CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 14 Feb 2017 09:19:27 -0800
Message-ID: <CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 7:01 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Thanks for your response...
>>
>>
>>
>> > +config MEMORY_SANITIZE
>> > +       bool "Enable memory sanitization features"
>> > +       select SLUB_DEBUG
>> > +       select PAGE_POISONING
>> > +       select PAGE_POISONING_NO_SANITY if HIBERNATION
>> > +       ---help---
>> > +       This option enables ...
>>
>> Good start! Why the "if HIBERNATION" bit? It seems like sanity checks
>> are very expensive, so we'd not want it as part of this config?
>>
> Okay, I wasn't sure. So would it be (more) correct to retain the first two
> configs plus
> PAGE_POISONING_NO_SANITY (without the if)?

I think so, yes. We may need to tweak it in the future, but I think
that's the correct config for now.

>> >  #if defined(CONFIG_SLUB_DEBUG_ON)
>> > +#if defined(CONFIG_MEMORY_SANITIZE)
>> > +/* With 'memory sanitize' On, slub_debug should be 'P' */
>> > +static int slub_debug = SLAB_POISON;
>> > +#else
>> >  static int slub_debug = DEBUG_DEFAULT_FLAGS;
>> > +#endif /* CONFIG_MEMORY_SANITIZE */
>> >  #else
>> >  static int slub_debug;
>> > -#endif
>> > +#endif /* CONFIG_SLUB_DEBUG_ON */
>>
>> Could the definition of DEBUG_DEFAULT_FLAGS be adjusted instead of
>> doing the ifdefs here in the .c file? Or, perhaps do a slub_debug |=
>> SLAB_POISON in memory_sanitize_init()?
>>
> Yes, the latter sounds good but the init function is in mm/page_poison.c and
> the slub_debug var is a static in mm/slub.c . Any suggestions?

Perhaps add another early_init like you did the page_poison.c?

-Kees

-- 
Kees Cook
Pixel Security
