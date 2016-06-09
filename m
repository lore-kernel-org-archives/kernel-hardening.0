Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160609195533.GE5421@thunk.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
 <5756BBC2.3735.D63200E@pageexec.freemail.hu> <20160607135857.GF7057@thunk.org>
 <5759A5D5.7023.18C58969@pageexec.freemail.hu> <20160609195533.GE5421@thunk.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 9 Jun 2016 13:08:53 -0700
Message-ID: <CAGXu5jJHE8LHdG2_j8L_LfraqMmCpwMiyeEMav7pxoKBR0_GCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc plugin
To: Theodore Ts'o <tytso@mit.edu>, PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Brown <david.brown@linaro.org>, emese Revfy <re.emese@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 9, 2016 at 12:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 09, 2016 at 07:22:29PM +0200, PaX Team wrote:
>> > Well, the attacker can't control when the interrupts happen, but it
>> > could try to burn power by simply having a thread spin in an infinite
>> > loop ("0: jmp 0"), sure.
>>
>> yes, that's one obvious way to accomplish it but even normal applications can
>> behave in a similar way, think about spinning event loops, media decoding, etc
>> whose sampled insn ptrs may provide less entropy than they get credited for.
>
> Sure, as long as we're assuming less than one bit of entropy per
> interrupt, even for a loop which which is:
>
> 1:   cmpl    $1, -8(%rsp)
>      jz      1b
>
> there would still be *some* uncertainty.  And with an event loop there
> would be more instructions to sample.  Granted, the number of cycles
> spent in each will be different, so there will be some biasing, but
> that's one of the reason why we've been using 1/64 bit per interrupt.
>
>> yes, no entropy is credited since i don't know how much there is and i tend to err
>> on the side of safety which means crediting 0 entropy for latent entropy. of course
>> the expectation is that it's not actually 0 but to prove any specific value or limit
>> is beyond my skills at least.
>
> Sure, that's fair.
>
>> i think it's not just per 64 interrupts but also after each elapsed second (i.e.,
>> whichever condition occurs first), so on an idle system (which i believe is more
>> likely to occur on exactly those small systems that the referenced paper was concerned
>> about) the credited entropy could be overestimated.
>
> That's a fair concern.  It might be that we should enforce some
> minimum (at least 8 interrupts in all cases), but this is where it's
> all about hueristics, especially on those systems that don't have random_get_entropy().
>
>> > In practice, on most modern CPU where we have a cycle counter,
>>
>> a quick check for get_cycles shows that at least these archs seem to return 0:
>> arc, avr32, cris, frv, m32r, m68k, xtensa. now you may not think of them as modern,
>> but they're still used in real life devices. i think that latent entropy is still
>> an option on them.
>
> It's possible for a system not to have a cycle counter, but to have
> something that can be used instead for random_get_entropy.  That's
> only being used for the m68k/amiga and mips/R6000[A] cases, but I keep
> hoping that the archiecture maintainers for osme of these other
> oddball platform (is that better than "non-modern"? :-) will come up
> with something, but yes, it is those platforms where I've always been
> the most worried.  On the one hand, if the hardware is crap, there's
> very little you can do.  Unfortnuately, very often these crap
> architectures have a very low BOM cost, so they are most likely to be
> used in IOT devices.   :-(
>
> One could try to claim that these IOT devics won't have upgradeable
> firmware and, so they'll probably be security disasters even without a
> good random number generators, but oddly, that doesn't give me much
> solace...
>
> And in the end, that may be the strongest argment for the
> latent_entropy plugin.  Even if it doesn't provide a lot of extra
> entropy, on those platforms we're going to be so starved of real
> entropy that almost anything will be better than what we have today.

Yeah, that's been my thinking around this. And on more sane systems,
using latent_entropy doesn't make things worse. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
