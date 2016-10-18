Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAAseMr4o9tGKHoC39b=gZTqYAKqFNPVsnW7wZCS2wFJJ7Wn2uw@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
 <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
 <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com>
 <CAGXu5jJf21U1zG5qO=imXSLBsMJBZRbc96xw0CSTPMm+C85yrg@mail.gmail.com>
 <CAAseMr49vEgQHuBq-pT0bHvRzwL9dUeceqwr87pVBk9ZjuoAig@mail.gmail.com>
 <CAGXu5jKad-W6dCU17dJD0SwubmjQ0=pR0zAUU2oR5NakWzoj-A@mail.gmail.com> <CAAseMr4o9tGKHoC39b=gZTqYAKqFNPVsnW7wZCS2wFJJ7Wn2uw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Oct 2016 14:21:21 -0700
Message-ID: <CAGXu5j+Fwa8kP7Lb+wcg=z1ovvpxHCr2UoOzOx0dTVXbKeeB4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: Gengjia Chen <chengjia4574@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Juerg Haefliger <juerg.haefliger@hpe.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 4:52 AM, Gengjia Chen <chengjia4574@gmail.com> wrote:
>> >2016-10-18 4:15 GMT+08:00 Kees Cook <keescook@chromium.org>:
>> >The ARM open/close depends on their use of Domains. For upstream,
>> >you'd have to examine how Domains are being used (which seems
>> >different to me).
>>
>> So, I will try to start to port pax_open_kernel/pax_close_kernel
>> arm-specific features to upstream, and keep you in touch.

Cool, feel free to post RFC patches even if they're not totally finished. :)

>> >The other work is building the in-kernel
>> >infrastructure to support write-rarely memory (likely a new section,
>> >like ro_after_init, etc).
>> >
>>
>> It seems that the constify plugin still not been ported to the lastest
>> code (v4.9-rc1),
>> If I understand, you means that a new section should be added
>> to the upstream , and cooperate with the future constify plugin (the
>> plugin automatically put those objects to that section ) ?

It hasn't been forward-ported, no, but building out the infrastructure
to support it in upstream will be needed regardless. In PaX, the
section is called .data..read_only, but I suspect that will turn out
to be a confusing name, since it's actually "write-rarely", but lives
in the .rodata section, and the open/close implementation will be used
to write to it.

The constify plugin actually moves variables into the .rodata section,
so not only does any code writing to such things need to be wrapped in
open/close calls, but the C compiler needs to be tricked into
generating sensible code (see PaX's const_cast() macro).

-Kees

-- 
Kees Cook
Nexus Security
