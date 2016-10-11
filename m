Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 12 Oct 2016 00:40:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161011234021.GA16858@remoulade>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
 <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
 <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com>
 <CAGXu5jJaAsED5=YX7RWtkHc8b219MEZ_7doohLUDics5nZY3ag@mail.gmail.com>
 <CAKv+Gu-LUZOCAYLi+DvNmuVjMC_0OMjZKkCu8+XfH_Z7RQbifQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-LUZOCAYLi+DvNmuVjMC_0OMjZKkCu8+XfH_Z7RQbifQ@mail.gmail.com>
Subject: Re: [kernel-hardening] initcall randomization
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 11, 2016 at 07:28:46PM +0100, Ard Biesheuvel wrote:
> vmalloc and ioremap calls will simply be served bottom up, which is
> why the beginning of the vmalloc area mostly looks the same between
> boots, i.e., all non-kaslr boots look identical, and all kaslr boots
> look identical with little variation.
> 
> I am aware that random vmalloc is a bad idea,

I must confess ignorance here; what problems does random vmalloc pose in
particular?

> hence my suggestion to perhaps randomize during the __init phase. I
> must admit that this is simply me holding the randomization hammer and
> looking for things that vaguely resemble nails, hence my request for
> discussion rather than proposing patches.

Do we have a particular threat model this helps with?

Is it similar to that for SLUB freelist randomization?

Do we have vmalloc area sepcific information leaks?

Thanks,
Mark.
