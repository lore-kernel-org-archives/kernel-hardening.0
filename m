MIME-Version: 1.0
In-Reply-To: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
References: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 3 Feb 2017 08:54:55 -0800
Message-ID: <CAJcbSZHRo-sGVcMVBkXJRdRJHyv9_8g9RHYuy8wfo8m2gRhnDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Container Hardening
To: Jessica Frazelle <me@jessfraz.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

That seems like a good idea!

It would be useful to gather a list of bugs that affected namespaces
or usual mistakes in using namespaces.

I will see if I can free some time to help.

On Fri, Feb 3, 2017 at 8:13 AM, Jessica Frazelle <me@jessfraz.com> wrote:
> Hi,
>
> I made this one page site[1] to detail trying to harden namespaces in
> the kernel. The other primitives containers use are included as well,
> but if we are honest we all know namespaces need the most help.
>
> Solar mentioned just using this mailing list for this initiative as
> well. That's great with me because I would love all your feedback and
> help.
>
> I think the first focus should be on preventing priviledge escalations
> in user namespaces. This has the largest attack surface. The
> fundamental problem seems to be that not many people have inspected
> user namespaces and the various interactions with other parts of the
> kernel. I will be trying to do this and would love any help from
> anyone interested. We could split up the various systems and do some
> research to find out just how far this rabbit hole goes.
>
> In the past, one of the ways to fix vulnerabilities with user
> namespaces was to disallow the interaction, for instance CLONE_FS.
>
> I'm sure we can't have that as a solution for everything, but I'm
> hoping by working together we can come up with a well-informed
> solution.
>
> Jess
>
> [1] https://containerhardening.org



-- 
Thomas
