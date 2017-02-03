MIME-Version: 1.0
In-Reply-To: <871svfytb0.fsf@xmission.com>
References: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
 <CAJcbSZHRo-sGVcMVBkXJRdRJHyv9_8g9RHYuy8wfo8m2gRhnDw@mail.gmail.com>
 <CAEk6tEz5XqKOytCSCYj3TfpXZDKSBS6aam-O1Aqp0Oz7-_RgNw@mail.gmail.com> <871svfytb0.fsf@xmission.com>
From: Jessica Frazelle <me@jessfraz.com>
Date: Fri, 3 Feb 2017 11:32:29 -0800
Message-ID: <CAEk6tEw5-19rZFHL2+-uw+sibegb1KAQj24jk8YZz3m_KE7TKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Container Hardening
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thank you for your help.

On Fri, Feb 3, 2017 at 11:25 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Jessica Frazelle <me@jessfraz.com> writes:
>
> > Yeah I can definitely come up with a list. The interesting thing is
> > some vulnerabilities don't even need for the process to be _in_ a user
> > namespace, just that CONFIG_USERNS=y. So as far as I currently know, a
> > lot has to do with hitting these obscure-ish code paths. But will work
> > on a list :)
>
> I believe you are a little misinformed about the current situation,
> but one thing I can agree with is more people and more eyeballs on the
> code can not hurt.
>
> My best estimate of where things are at is at this point most of the
> design issues have been fixed, and that user namespaces and namespaces
> in general are about as buggy as the rest of the kernel.
>
> As any process can create a user namespace a system does not have to be
> using user namespaces to be vulnerable to their issues.  At the same
> time there are a set of sysctls under /proc/sys/user/ that can be used
> to reduce the attack surface if you are not using the features.
>

This sounds neat, I will read up on it!

>
> I will be happy to help resolve and merge any bugs you happen to find.
>
> Although if they are ordinary kernel bugs in the network stack it is
> probably easiest just to go through David Miller, and the netdev mailing
> list.  I won't mind being Cc'd in that case.
>
> Eric
