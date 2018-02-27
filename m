Date: Wed, 28 Feb 2018 08:06:25 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 1/3] leaking_addresses: skip all /proc/PID except /proc/1
Message-ID: <20180227210625.GA2646@eros>
References: <1519706711-18580-1-git-send-email-me@tobin.cc>
 <1519706711-18580-2-git-send-email-me@tobin.cc>
 <CAJ1xhMWfAZnQXoYVLLf6ABQ1+JsfLyJZmr95-33LH1DFJ5NjXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ1xhMWfAZnQXoYVLLf6ABQ1+JsfLyJZmr95-33LH1DFJ5NjXA@mail.gmail.com>
To: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 27, 2018 at 09:15:03AM +0200, Alexander Kapshuk wrote:
> On Tue, Feb 27, 2018 at 6:45 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > When the system is idle it is likely that most files under /proc/PID
> > will be identical for various processes.  Scanning _all_ the PIDs under
> > /proc is unnecessary and implies that we are thoroughly scanning /proc.
> > This is _not_ the case because there may be ways userspace can trigger
> > creation of /proc files that leak addresses but were not present during
> > a scan.  For these two reasons we should exclude all PID directories
> > under /proc except '1/'
> >
> > Exclude all /proc/PID except /proc/1.
> >
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> >  scripts/leaking_addresses.pl | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > index 6e5bc57caeaa..fb40e2828f43 100755
> > --- a/scripts/leaking_addresses.pl
> > +++ b/scripts/leaking_addresses.pl
> > @@ -10,6 +10,14 @@
> >  # Use --debug to output path before parsing, this is useful to find files that
> >  # cause the script to choke.
> >
> > +#
> > +# When the system is idle it is likely that most files under /proc/PID will be
> > +# identical for various processes.  Scanning _all_ the PIDs under /proc is
> > +# unnecessary and implies that we are thoroughly scanning /proc.  This is _not_
> > +# the case because there may be ways userspace can trigger creation of /proc
> > +# files that leak addresses but were not present during a scan.  For these two
> > +# reasons we exclude all PID directories under /proc except '1/'
> > +
> >  use warnings;
> >  use strict;
> >  use POSIX;
> > @@ -472,6 +480,9 @@ sub walk
> >                         my $path = "$pwd/$file";
> >                         next if (-l $path);
> >
> > +                       # skip /proc/PID except /proc/1
> > +                       next if ($path =~ /\/proc\/(?:[2-9][0-9]*|1[0-9]+)/);
> > +
> >                         next if (skip($path));
> >
> >                         if (-d $path) {
> > --
> > 2.7.4
> >
> 
> Would something like this do the trick?
> perl -e 'foreach my $dir (`ls -d /proc/[0-9]*`){next if($dir !~
> "/proc/1\$"); print $dir}'
> /proc/1

thanks for the suggestion Alexander.  Here is Tycho's suggestion (from
other email, copied here for reference:

	> substr($path, 0, len("/proc/1/")) eq "/proc/1/"

I originally thought Tycho's suggestion was correct until I read yours
and realized that they both find '/proc/1'.  You filter on the numbered
directories for '/proc/1' (missing the other directories) and Tycho
finds only directories with '/proc/1' as the leading characters.  Both
of these differ to the original regex in that the original skips
numbered directories (under '/proc') that are _not_ '/proc/1' i.e it
allows parsing of all the non-numbered directories and parsing of '/proc/1'.

If my reasoning is correct, perhaps we have at least shown that that the
regex should have a comment :)

Happy to be corrected.

thanks,
Tobin.
