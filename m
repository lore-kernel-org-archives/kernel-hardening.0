Date: Thu, 9 Nov 2017 11:51:42 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171109005142.GF27823@eros>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
 <1510112259-11572-5-git-send-email-me@tobin.cc>
 <20171108104221.GH2652@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108104221.GH2652@pathway.suse.cz>
Subject: [kernel-hardening] Re: [PATCH 4/7] scripts/leaking_addresses: add reporting
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 08, 2017 at 11:42:21AM +0100, Petr Mladek wrote:
> On Wed 2017-11-08 14:37:36, Tobin C. Harding wrote:
> > Currently script just dumps all results found. Potentially, this risks
> > loosing single results among multiple duplicate results. We need some
> > way of restricting duplicates to assist users of the script. It would
> > also be nice if we got a report instead of raw results.
> > 
> > Duplicates can be defined in various ways, instead of trying to find a
> > single perfect solution we can present the user with various options to
> > display the output. Doing so will typically lead to users wanting to
> > view the output multiple times. Currently we scan the kernel each time,
> > this is slow and unnecessary. We can expedite the process by writing the
> > results to file for subsequent viewing.
> > 
> > Add sub-commands `scan` and `format`. Display output as a report instead
> > of raw results. Add --raw flag to view raw results. Save results to
> > file. For subsequent calls to `format` parse output file instead of
> > re-scanning.
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> >  scripts/leaking_addresses.pl | 201 ++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 187 insertions(+), 14 deletions(-)
> > 
> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > index 719ed0aaede7..4c31e935319b 100755
> > --- a/scripts/leaking_addresses.pl
> > +++ b/scripts/leaking_addresses.pl
> > @@ -21,14 +21,19 @@ use File::Spec;
> >  use Cwd 'abs_path';
> >  use Term::ANSIColor qw(:constants);
> >  use Getopt::Long qw(:config no_auto_abbrev);
> > +use File::Spec::Functions 'catfile';
> >  
> >  my $P = $0;
> >  my $V = '0.01';
> >  
> > -# Directories to scan.
> > +# Directories to scan (we scan `dmesg` also).
> >  my @DIRS = ('/proc', '/sys');
> >  
> >  # Command line options.
> > +my $output = "scan.out";
> 
> The hard-coded filename and its use is dangerous. Nobody expects that
> this kind of script writes/re-writes a file on the system.

Understood.

> > +my $suppress_dmesg = 0;
> > +my $squash_by_path = 0;
> > +my $raw = 0;
> >  my $help = 0;
> >  my $debug = 0;
> >  
> > @@ -70,21 +75,34 @@ sub help
> >  	my ($exitcode) = @_;
> >  
> >  	print << "EOM";
> > -Usage: $P [OPTIONS]
> > +
> > +Usage: $P COMMAND [OPTIONS]
> >  Version: $V
> >  
> > +Commands:
> > +
> > +	scan	Scan the kernel (savesg raw results to file and runs `format`).
> > +	format	Parse results file and format output.
> 
> The later formatting/filtering might be useful but the use
> of the hard coded file is strange. Also it is pity that
> the script does not do anything useful out of box.
> 
> I suggest to remove the commands and do the scan out of box.
> It should not store anything on the disk by default.
> 
> Then we could define following options:
> 
>     -o, --output=<file>	 Store raw results into file for later formatting.
>     -i, --input=<file>   Read raw result from file and just format them.
> 
> Well, it is still somehow non-intuitive. It might help to
> be more explicit:
> 
>     -o, --output-raw=<file>
>     -i, --input-raw=<file>

So,

 Usage: scripts/leaking_addresses.pl [OPTIONS]

 Options:

	-o, --output-raw=<file>	 Save results for future processing.
	-i, --input-raw=<file>	 Read results from file instead of scanning.
	    --raw		 Show raw results (default).
	    --suppress-dmesg	 Do not show dmesg results.
	    --squash-by-path	 Show one result per unique path.
  	    --squash-by-filename Show one result per unique filename.
	-d, --debug              Display debugging output.
	-h, --help, --version    Display this help and exit.

> >  Options:
> >  
> > -	-d, --debug                Display debugging output.
> > -	-h, --help, --version      Display this help and exit.
> > +	-o, --output=<file>	 Raw results output file, used for later formatting.
> > +	    --suppress-dmesg	 Do not show dmesg results.
> > +	    --squash-by-path	 Show one result per unique path.
> 
> I would personally add also option for the default mode:
> 
> 	    --squash-by-filename Show one result per unique filename
> 				 (default).
> 
> In fact, I would personally use --squash-by-path or even --raw by
> default. These provide easy to understand output. While the
> --squash-by-filename mode has pretty good results but
> it is quite non-intuitive.

Thanks for you suggestions Petr. Summary reporting by default was
suggested by Linus, but now the summary is implemented and has proven to
be heuristic I tend to agree with you that raw by default is
best. This gives users the information they need to select one of the
summary types i.e if raw output has a bunch of lines from different
paths but all filename FOO then --squash-by-filename may be used.

Thanks for the tips, it's much nicer without the sub-commands.

thanks,
Tobin.
