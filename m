Date: Tue, 7 Nov 2017 11:50:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171107105027.GA1464@kroah.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510050731-32446-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH v4] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 07, 2017 at 09:32:11PM +1100, Tobin C. Harding wrote:
> Currently we are leaking addresses from the kernel to user space. This
> script is an attempt to find some of those leakages. Script parses
> `dmesg` output and /proc and /sys files for hex strings that look like
> kernel addresses.
> 
> Only works for 64 bit kernels, the reason being that kernel addresses
> on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> possible. On 32 kernels we don't have this luxury.
> 
> Scripts is _slightly_ smarter than a straight grep, we check for false
> positives (all 0's or all 1's, and vsyscall start/finish addresses).
> 
> Output is saved to file to expedite repeated formatting/viewing of
> output.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
> 
> This version outputs a report instead of the raw results by default. Designing
> this proved to be non-trivial, the reason being that it is not immediately clear
> what constitutes a duplicate entry (similar message, address range, same
> file?). Also, the aim of the report is to assist users _not_ missing correct
> results; limiting the output is inherently a trade off between noise and
> correct, clear results.
> 
> Without testing on various real kernels its not clear that this reporting is any
> good, my test cases were a bit contrived. Your usage may vary.
> 
> It would be super helpful to get some comments from people running this with
> different set ups.
> 
> Please feel free to say 'try harder Tobin, this reporting is shit'.
> 
> Thanks, appreciate your time,
> Tobin.
> 
> v4:
>  - Add `scan` and `format` sub-commands.
>  - Output report by default.
>  - Add command line option to send scan results (to me).

As the script is already in Linus's tree, you might need to send a patch
on top of that, instead of this one, as this one will not apply anymore.

thanks,

greg k-h
