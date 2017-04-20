From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CACi5LpNepcyCgWj-bYnSWqNRDtE97wVJ6=shM2mRP3i0ROx+qg@mail.gmail.com>
References: <1492612181-8484-1-git-send-email-mpe@ellerman.id.au> <CACi5LpNepcyCgWj-bYnSWqNRDtE97wVJ6=shM2mRP3i0ROx+qg@mail.gmail.com>
Date: Thu, 20 Apr 2017 21:00:35 +1000
Message-ID: <87efwn4a3w.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] powerpc/mm: Add support for runtime configuration of ASLR limits
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: linuxppc-dev@ozlabs.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Bhupesh,

Bhupesh Sharma <bhsharma@redhat.com> writes:
> On Wed, Apr 19, 2017 at 7:59 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Add powerpc support for mmap_rnd_bits and mmap_rnd_compat_bits, which are two
>> sysctls that allow a user to configure the number of bits of randomness used for
>> ASLR.
...
>>
>> The result of that is that we have to define the default values based on both
>> 32-bit vs 64-bit, but also the configured PAGE_SIZE. Furthermore now that we
>> have 128TB address space support on Book3S, we also have to take that into
>> account.
>
> Thanks for the patch. I have a couple of comments:
>
> (A) As Aneesh noted in the review of my v2 patch (see [1]), we need to
> handle the configurable 512TB case as well. Right?

No we don't need to handle 512TB, at least for now.

A process has to opt-in to using the address space above 128TB, and it
does that by calling mmap() with a hint above 128TB.

But by the time the process is running, and can call mmap(), we have
already finished calling arch_mmap_rnd() for that process. Once to
randomise where we load the executable if it's ET_DYN (in load_elf_binary()),
and the other to choose the mmap_base (arch_pick_mmap_layout()).

In future I suspect we might want to optionally use the full address
space for ASLR, and if/when that happens then we'll need to do something
differently.

>> Finally we can wire up the value in arch_mmap_rnd().
>>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>
> (b) I am wondering if I missed your comments on my v2 on the same
> subject - may be you missed my reminder message (see [2]).

Your v3 was OK, and I would have merged it except I knew it needed
reworking because of the 128TB address space change.

I was waiting for you to do a v4 based on the 128TB changes, but then
last night I saw your message asking which tree to base that on and so I
decided to quickly do it myself so as to not miss v4.12.

> I am just starting off on PPC related enhancements that we find useful
> while working on Redhat/Fedora PPC systems (I have mainly been
> associated with ARM and peripheral driver development in the past),
> and would have been motivated further if I could get responses to my
> queries which I had raised earlier on the list (see [3]) - especially
> the branch to base newer version of patches on.

Sure. I know this has dragged on, it's one of those changes that seems
simple but isn't really. And then it collided with the 128TB changes
which made it more complicated again.

Sorry I didn't respond to your query on which tree to use, but I get a
lot of email and some days I just don't get through it all - or indeed
any of it :)

For a quick query like that you might be better asking on IRC, I and a
bunch of other folk who could have answered that question sit in #ppc64
on Freenode, feel free to join.


My next branch is here:
  https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=next

And it's also included in linux-next.

In general you should just use Linus' master branch to base new work on.
But in this case you did need to use my next because the 128TB changes
are in there and this patch is dependent on them.

> Also I am not sure how the PPC subsystem handles S-O-Bs of earlier
> contributions on the same subject (as it varies from one
> maintainer/subsystem to the other), so I leave it up to you.

I don't think we handle them any differently. In this case I had this
patch already written, I sent some of it to you earlier remember, so it
wasn't actually based on your patch. But I'm happy to add your SOB,
and/or Ack/Tested by.

cheers
