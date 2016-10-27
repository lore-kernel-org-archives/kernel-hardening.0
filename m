Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161027135337.GB30535@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <20161027103143.GB27135@leverpostej> <CAEXv5_iLo5ezNBFiMbQ91Nj_dh41uWZiMtxCynAsCZhO+2wHpw@mail.gmail.com>
 <20161027135337.GB30535@leverpostej>
From: David Windsor <dave@progbits.org>
Date: Thu, 27 Oct 2016 10:10:22 -0400
Message-ID: <CAEXv5_go_ft0C4XZkk3xFcAgFUEsgyYWx96GE4Ced=vcUn=90g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC 0/2] arm: implementation of HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 9:53 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Thu, Oct 27, 2016 at 08:45:33AM -0400, David Windsor wrote:
>> On Thu, Oct 27, 2016 at 6:32 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > Unfortunately, I'm only somewhat familiar with the ARM atomics, and I
>> > have absolutely no familiarity with the existing PaX patchset.
>> >
>> > For both of these, some background rationale would be helpful. e.g. what
>> > does the fixup entry do? When is it invoked?
>>
>> For your reference, documentation on the original PaX protection
>> (known there a PAX_REFCOUNT) can be found here:
>> https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
>
> Thanks; that's very helpful. For subsequent postings it would be worth
> referring to this in the cover letter, along with a rough summary.
>
>> With respect to documentation, there is a patch in this series that
>> adds Documentation/security/hardened-atomic.txt, which references the
>> above-mentioned forum post.
>
> Unfortunately, that's not part of *this* series, and the prerequisite
> series with this was not linked to. I can find that by going through the
> list, but for the sake of others, having an explicit link to the
> relevant version of the other series would be more helpful.
>

Ah yes, you're right, the HARDENED_ATOMIC documentation patch isn't
part of this series at all!

My point was, might we want to do something with the original forum
post to make it more suitable for "long term storage"?  Maybe a forum
post is the appropriate venue for a project's technical documentation;
I don't feel qualified to make this determination.

> Thanks,
> Mark.
