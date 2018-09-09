Date: Sun, 9 Sep 2018 12:56:47 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Checked C?
Message-ID: <20180909165647.GC22251@thunk.org>
References: <CACXcFmki+t-TvaiYxfOyphkF+LRQcJHFQjgW31HrYGRhOCYrEg@mail.gmail.com>
 <20180909125912.GA17863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180909125912.GA17863@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Sandy Harris <sandyinchina@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Sep 09, 2018 at 02:59:12PM +0200, Greg KH wrote:
> On Sun, Sep 09, 2018 at 08:22:44AM -0400, Sandy Harris wrote:
> > Slashdot reports that Microsoft have come up with something they call
> > "checked C". It claims to prevent a wide variety of memory & pointer
> > bugs, using a mix of compile-time and run-time checks, at moderate
> > overheads.
> > 
> > Implementation is as extensions to Clang so it might be hard to apply
> > to the kernel which I think has some GNU-isms. Perhaps still worth a
> > look?

What would be really interesting would be implementing the Microsoft
extensions as Clang plugins, so the kernel changes don't require
distributions to ship a modified Clang.

Whoever does this will need to remember that kernel modifications need
to work with:

   * Clang with the extensions

   * Clang without the extensions (in case the extensions are Clang
     version dependent, and the system has a Clang which is too old).

   * Gcc without the extensions

We've been doing that sort of thing already, using CPP magic, so there
are plenty of examples about ways of doing that.

    	       	     	       	  	- Ted
