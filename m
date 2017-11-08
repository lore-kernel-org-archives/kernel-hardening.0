Date: Wed, 8 Nov 2017 11:16:43 +0100
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20171108101643.GG2652@pathway.suse.cz>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
 <1510112259-11572-6-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510112259-11572-6-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH 5/7] scripts/leaking_addresses: add emailing results
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed 2017-11-08 14:37:37, Tobin C. Harding wrote:
> Developers may not have the time (or inclination) to investigate script
> output. This information is, however, useful. If we add functionality to
> the script to email results for further investigation.
> 
> Add --send-report flag to email scan results (to Tobin C. Harding).

I am not sure that it is wise to make spaming one person
so easy ;-)

It might make sense to add some more information into
the message. For example:

    + uname -a
    + whether the log was generated using root access

Also people might feel more comfortable if this feature:

     + prints the message
     + printks where it is being sent
     + ask yes/no before doing so


>  scripts/leaking_addresses.pl | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>  mode change 100755 => 100644 scripts/leaking_addresses.pl
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> old mode 100755
> new mode 100644

I guess that this was not intended.

Best Regards,
Petr
