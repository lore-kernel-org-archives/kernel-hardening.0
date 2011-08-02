Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110801190341.GA6898@albatros>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 14:01:38 -1000
Message-ID: <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs. threads)
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 1, 2011 at 9:03 AM, Vasiliy Kulikov <segoon@openwall.com> wrote=
:
>> Are we talking about init_ipc_ns.ids[] here? =A0If so, did you try
>> initializing the three rwsems at compile-time?
>>
>> That's rather a nasty hack though. =A0It'd be better to run the mystery
>> init function before starting the threads.
>
> Looks like it solves the race. =A0However, I think it should be solved on
> another level. =A0Other bugs might be hidden with this race.

Statically initializing code data structures in order to avoid these
kinds of problems is the correct fix.

Can you send me the patch?

              Linus
