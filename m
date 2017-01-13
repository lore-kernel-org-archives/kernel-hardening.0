Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1484344621.3381.2.camel@gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <20170113082347.GJ20972@linaro.org> <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
 <5879219B.26854.33C60FDB@pageexec.freemail.hu> <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
 <1484344621.3381.2.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Jan 2017 14:04:58 -0800
Message-ID: <CAGXu5jLuo8NrhowJVTxLq-GX0eBrL+c2Tyd4k5TbHP5eEG0oFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: PaX Team <pageexec@freemail.hu>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 1:57 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Fri, 2017-01-13 at 11:06 -0800, Kees Cook wrote:
>> On Fri, Jan 13, 2017 at 10:51 AM, PaX Team <pageexec@freemail.hu>
>> wrote:
>> > On 13 Jan 2017 at 9:54, Kees Cook wrote:
>> >
>> > > PaX Team, the heuristic for STRUCTLEAK appears to be "does the
>> > > struct
>> > > contain anything marked __user". Is this actually a meaningful
>> > > information exposure case? It seems like there are a lot more
>> > > cases
>> > > for exposures where there is nothing marked __user. Is that the
>> > > meaning of "much smaller coverage" compared to STACKLEAK in the
>> > > Kconfig?
>> >
>> > STRUCTLEAK was written in response to a particular bug a few years
>> > ago
>> > where we didn't want to give the bug away but still wanted to fix it
>> > during the embargo. the struct in question could be matched by this
>> > heuristics, matching everything else (however little of it) is
>> > really
>> > just a free side effect. could coverage be improved? of course but
>> > that
>> > would take a whole lot more work (manual markups and/or data flow
>> > analysis
>> > in LTO mode).
>>
>> Out of curiosity, do you remember which bug? I'd be curious to compare
>> it against others. It seems like adding structleak to upstream still
>> has value, even if the coverage isn't as complete as stackleak.
>
> There's the performance-oblivious approach of zeroing all locals early
> in the compiler pipeline and relying on compiler optimizations to remove
> it when it's not required. They're already pretty good at doing it.

Yeah, I think that's what happens here. Some initializations are seen
as constructors still, while others are marked as SSAs already.
Hopefully the optimization pass will correctly collapse the cases.

-Kees

-- 
Kees Cook
Nexus Security
