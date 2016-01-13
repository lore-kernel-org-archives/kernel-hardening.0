Reply-To: kernel-hardening@lists.openwall.com
From: Daniel Axtens <dja@axtens.net>
In-Reply-To: <20160113002043.GA17146@openwall.com>
References: <1452626745-31708-1-git-send-email-jann@thejh.net> <87mvsa5q40.fsf@gamma.ozlabs.ibm.com> <20160113002043.GA17146@openwall.com>
Date: Wed, 13 Jan 2016 11:33:56 +1100
Message-ID: <87h9ii5nd7.fsf@gamma.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [RFC] kernel/panic: place an upper limit on number of oopses
To: Solar Designer <solar@openwall.com>
Cc: Jann Horn <jann@thejh.net>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>

Solar Designer <solar@openwall.com> writes:

> Jann Horn <jann@thejh.net> wrote:
>> To prevent an attacker from turning a mostly harmless oops into an
>> exploitable issue using a refcounter wraparound caused by repeated
>> oopsing, limit the number of oopses.
>
> This may also reduce the likelihood of successful exploitation of some
> other vulnerabilities involving memory corruption, where an unsuccessful
> attempt may inadvertently trigger an Oops.  The attacker would then need
> to succeed in fewer than the maximum allowed number of Oops'es.  Jann's
> currently proposed default of 0x100000 is too high to make a difference
> in that respect, but people may set it differently.
>
> On Wed, Jan 13, 2016 at 10:34:39AM +1100, Daniel Axtens wrote:
>> I'm torn between making the limit configurable and not adding to the
>> massive proliferation of config options.
>
> What about reusing panic_on_oops for the configurable limit?  The
> currently supported values of 0 and 1 would retain their meaning,
> 2 would panic after 2nd Oops, and so on.

I thought about this, then I looked at where panic_on_oops was used and
I thought it would be a pretty invasive change. I'm also nervous about
changing the semantics of panic_on_oops under people...

>
> There's overlap with grsecurity's banning of users on Oops, but I think
> it makes sense to have both the trivial change proposed by Jann (perhaps
> with the reuse of panic_on_oops for configuration) and grsecurity-style
> banning (maybe with a low configurable limit, rather than always on
> first Oops).
>
> Alexander
