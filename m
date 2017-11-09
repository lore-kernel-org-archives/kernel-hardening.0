From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:27 +1100
Message-Id: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 0/8] scripts/leaking_addresses: add summary reporting
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This series adds summary reporting to the script. First we do some clean
up. Then we implement changes that were first posted as

[PATCH v4] scripts: add leaking_addresses.pl

Additionally; files (and paths) to skip is amended, thanks to Michael
Ellerman and Kees Cook.

Support for scanning PowerPC (64 bit) is added, with thanks to Michael
Ellerman.

File read timeout is added, we set the timer before parsing each
file. Suggested by Kees Cook.

$ perl scripts/leaking_addresses.pl --help

Usage: scripts/leaking_addresses.pl [OPTIONS]
Version: 0.01

Options:

	-o, --output-raw=<file>  Save results for future processing.
	-i, --input-raw=<file>   Read results from file instead of scanning.
	    --raw                Show raw results (default).
	    --suppress-dmesg     Do not show dmesg results.
	    --squash-by-path     Show one result per unique path.
	    --squash-by-filename Show one result per unique filename.
	-d, --debug              Display debugging output.
	-h, --help, --version    Display this help and exit.

Examples:

	# Scan kernel and dump raw results.
	scripts/leaking_addresses.pl

	# Scan kernel and save results to file.
	scripts/leaking_addresses.pl --output-raw scan.out

	# View summary report.
	scripts/leaking_addresses.pl --input-raw scan.out --squash-by-filename

Scans the running (64 bit) kernel for potential leaking addresses.

thanks,
Tobin.

Changes since v1:
 - Basically everything except the summary reporting, including re-write
   of the cover-letter. 

Tobin C. Harding (8):
  scripts/leaking_addresses: use tabs not spaces
  scripts/leaking_addresses: remove dead code
  scripts/leaking_addresses: remove command line options
  scripts/leaking_addresses: fix comment typo
  scripts/leaking_addresses: add to exclude files/paths
  scripts/leaking_addresses: add summary reporting
  scripts/leaking_addresses: add support for ppc64
  scripts/leaking_addresses: add timeout on file read

 scripts/leaking_addresses.pl | 369 +++++++++++++++++++++++++++++++++----------
 1 file changed, 282 insertions(+), 87 deletions(-)

-- 
2.7.4
