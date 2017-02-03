From: ebiederm@xmission.com (Eric W. Biederman)
References: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
	<CAJcbSZHRo-sGVcMVBkXJRdRJHyv9_8g9RHYuy8wfo8m2gRhnDw@mail.gmail.com>
	<CAEk6tEz5XqKOytCSCYj3TfpXZDKSBS6aam-O1Aqp0Oz7-_RgNw@mail.gmail.com>
Date: Sat, 04 Feb 2017 08:21:07 +1300
In-Reply-To: <CAEk6tEz5XqKOytCSCYj3TfpXZDKSBS6aam-O1Aqp0Oz7-_RgNw@mail.gmail.com>
	(Jessica Frazelle's message of "Fri, 3 Feb 2017 10:04:14 -0800")
Message-ID: <871svfytb0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Container Hardening
To: Jessica Frazelle <me@jessfraz.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Jessica Frazelle <me@jessfraz.com> writes:

> Yeah I can definitely come up with a list. The interesting thing is
> some vulnerabilities don't even need for the process to be _in_ a user
> namespace, just that CONFIG_USERNS=y. So as far as I currently know, a
> lot has to do with hitting these obscure-ish code paths. But will work
> on a list :)

I believe you are a little misinformed about the current situation,
but one thing I can agree with is more people and more eyeballs on the
code can not hurt.

My best estimate of where things are at is at this point most of the
design issues have been fixed, and that user namespaces and namespaces
in general are about as buggy as the rest of the kernel.

As any process can create a user namespace a system does not have to be
using user namespaces to be vulnerable to their issues.  At the same
time there are a set of sysctls under /proc/sys/user/ that can be used
to reduce the attack surface if you are not using the features.

I will be happy to help resolve and merge any bugs you happen to find.

Although if they are ordinary kernel bugs in the network stack it is
probably easiest just to go through David Miller, and the netdev mailing
list.  I won't mind being Cc'd in that case.

Eric
