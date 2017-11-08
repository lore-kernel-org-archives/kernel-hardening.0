Date: Thu, 9 Nov 2017 08:16:08 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171108211608.GC27823@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <87k1z12cof.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1z12cof.fsf@concordia.ellerman.id.au>
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 08, 2017 at 11:10:56PM +1100, Michael Ellerman wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
> > Currently we are leaking addresses from the kernel to user space. This
> > script is an attempt to find some of those leakages. Script parses
> > `dmesg` output and /proc and /sys files for hex strings that look like
> > kernel addresses.
> >
> > Only works for 64 bit kernels, the reason being that kernel addresses
> > on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> > possible.
> 
> That doesn't work super well on other architectures :D
> 
> I don't speak perl but presumably you can check the arch somehow and
> customise the regex?

I'm on it.

> ...
> > +# Return _all_ non false positive addresses from $line.
> > +sub extract_addresses
> > +{
> > +        my ($line) = @_;
> > +        my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
> 
> On 64-bit powerpc (ppc64/ppc64le) we'd want:
> 
> +        my $address = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';

This is great! Thanks a million. This gives me the idea of getting in
contact with people who have access to other [64 bit] architectures and
getting the address format. I guess a dump of kallsyms from each
architecture would do the job nicely. 

> > +# Do not parse these files (absolute path).
> > +my @skip_parse_files_abs = ('/proc/kmsg',
> > +			    '/proc/kcore',
> > +			    '/proc/fs/ext4/sdb1/mb_groups',
> > +			    '/proc/1/fd/3',
> > +			    '/sys/kernel/debug/tracing/trace_pipe',
> > +			    '/sys/kernel/security/apparmor/revision');
> 
> Can you add:
> 
>   /sys/firmware/devicetree
> 
> and/or /proc/device-tree (which is a symlink to the above).

Can do, thanks.

> We should also start restricting access to that because it may have
> potentially interesting physical addresses in it, but that will break
> existing tools, so it will need to be opt-in and done over time.

Seems like this is going to be a recurring theme if we try to stop leaks
using file permissions. I'm interested in how we would do this, assuming
it has to be a case by case fix but done many times.

thanks,
Tobin.
