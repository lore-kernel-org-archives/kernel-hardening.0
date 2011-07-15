Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110715063801.GC3166@albatros>
References: <20110703103925.GA2283@albatros> <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
 <20110704201339.GA5645@albatros> <20110705141301.0d3594e0.akpm@linux-foundation.org>
 <20110706163412.GA4743@albatros> <20110715063801.GC3166@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Jul 2011 09:14:30 -0700
Message-ID: <CA+55aFxE+zEhDXyXurasBJHjaQEi6Ge1kMQamwdGfiUY8WsshQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v3] proc: fix a race in do_io_accounting()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 14, 2011 at 11:38 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> Any problems with the patch?

I still think that the problem you fixed is simply not important, and
the problem that I actually might care about (the ad-hoc and
inconsistent rules) remains.

So the patch is just a "not important enough to care about" for me,
and if it comes in through Andrew I'll probably take it, but it's
merge-window material rather than anything else.

                              Linus
