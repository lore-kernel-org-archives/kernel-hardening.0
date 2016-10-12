Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161011234021.GA16858@remoulade>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
 <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
 <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com>
 <CAGXu5jJaAsED5=YX7RWtkHc8b219MEZ_7doohLUDics5nZY3ag@mail.gmail.com>
 <CAKv+Gu-LUZOCAYLi+DvNmuVjMC_0OMjZKkCu8+XfH_Z7RQbifQ@mail.gmail.com> <20161011234021.GA16858@remoulade>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Oct 2016 09:55:03 +0100
Message-ID: <CAKv+Gu8dP33UYh-Vq1z-kXa+R_nXrFqpVOTsCW7qc2excrN4AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] initcall randomization
To: Mark Rutland <mark.rutland@arm.com>, Nick Kralevich <nnk@google.com>
Cc: kernel-hardening@lists.openwall.com, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

(+ Nick)

On 12 October 2016 at 00:40, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Oct 11, 2016 at 07:28:46PM +0100, Ard Biesheuvel wrote:
>> vmalloc and ioremap calls will simply be served bottom up, which is
>> why the beginning of the vmalloc area mostly looks the same between
>> boots, i.e., all non-kaslr boots look identical, and all kaslr boots
>> look identical with little variation.
>>
>> I am aware that random vmalloc is a bad idea,
>
> I must confess ignorance here; what problems does random vmalloc pose in
> particular?
>

It has been attempted in Android, and resulted in vmalloc failures due
to fragmentation. I realize this may not apply to 64-bit ARM, though
(and I assume the Android example concerned 32-bit ARM)

>> hence my suggestion to perhaps randomize during the __init phase. I
>> must admit that this is simply me holding the randomization hammer and
>> looking for things that vaguely resemble nails, hence my request for
>> discussion rather than proposing patches.
>
> Do we have a particular threat model this helps with?
>
> Is it similar to that for SLUB freelist randomization?
>
> Do we have vmalloc area sepcific information leaks?
>

Well, that was my question as well. Given that it seemed like a good
idea for the Android guys at the time, I would assume yes

Nick?
