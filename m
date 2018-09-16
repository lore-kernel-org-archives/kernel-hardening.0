MIME-Version: 1.0
References: <1536516257-30871-1-git-send-email-s.mesoraca16@gmail.com> <20180909142741.3b87df76@lwn.net>
In-Reply-To: <20180909142741.3b87df76@lwn.net>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 16 Sep 2018 19:38:56 +0200
Message-ID: <CAJHCu1J4+K3q2ce0k-hMOJdsSJ8yV+7iXROj0BjNgO87B_Hj+g@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: corbet@lwn.net
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, keescook@chromium.org, labbott@redhat.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, ebiederm@xmission.com
List-ID: <kernel-hardening.lists.openwall.com>

Jonathan Corbet <corbet@lwn.net> wrote:
> [omissis]
>
> Some overall thoughts:
>
> - As Sam asked: who are the users of this feature?  Presumably you have
>   some real people out there in mind for each of these levels, or you would
>   not have created them?

In general this feature will be useful for all those people who are
interested in enabling hardening features on their kernel.
Maybe they are not so many, but they exist and are the reason why
KSPP's list and kconfig-hardened-check script were written.
Anyway, not everybody is willing to trade a lot of performance for security.
I hope that splitting features based on their negative impact will
increase the usage of those features which are more "usable", but
still not so known by many people.

> - Who will maintain it?  The list of hardening-relevant configuration
>   options is always in high flux, as our understanding of the security
>   implications of each.  This feature will require some significant ongoing
>   attention or it will quickly become stale.  I think it needs a
>   MAINTAINERS entry.

Good, I can add myself as maintainer, I also got Kees permission to
add him as designated reviewer too.

> - It's a little strange to see an RST document used as the input for the
>   kernel configuration process.  Assuming this is really the best way to do
>   this (and I worry about things like duplicated descriptions of kernel
>   configuration options), you should, at a minimum, carefully document the
>   format of this file at the beginning.  Otherwise people will surely break
>   it.  In fact, they'll break it anyway, so more checking in the processing
>   script seems indicated.

Yes, this approach is a bit "original". I think your suggestions are sensible.
I'll document better the format and add more checks to the script to
make it more resilient.

>   Without having thought it through in great depth, I suspect that a better
>   approach might be to find a way to mark the hardening level in the
>   Kconfig entries.

The reason why everything starts from an .rst is that I'd like to have
a doc page with a detailed list of all the hardening feature.
If the fragments aren't going to be generated from the doc we'll a way
to make sure that what is written in the doc is coherent with what
Kconfig is doing.
I'm don't think that it will be much better.

> - You have ordered the options alphabetically, but that is, I would argue,
>   not the best way.  My guess is that people would read this file to answer
>   the question of "just how many bullets will hardening level H put into my
>   foot?"  So I would sort them by hardening level as the primary key.

This seems reasonable, I'll change it.

Thank you for your time,

Salvatore
