Date: Sun, 9 Sep 2018 14:59:12 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: Checked C?
Message-ID: <20180909125912.GA17863@kroah.com>
References: <CACXcFmki+t-TvaiYxfOyphkF+LRQcJHFQjgW31HrYGRhOCYrEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmki+t-TvaiYxfOyphkF+LRQcJHFQjgW31HrYGRhOCYrEg@mail.gmail.com>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Sep 09, 2018 at 08:22:44AM -0400, Sandy Harris wrote:
> Slashdot reports that Microsoft have come up with something they call
> "checked C". It claims to prevent a wide variety of memory & pointer
> bugs, using a mix of compile-time and run-time checks, at moderate
> overheads.
> 
> Implementation is as extensions to Clang so it might be hard to apply
> to the kernel which I think has some GNU-isms. Perhaps still worth a
> look?

The kernel builds just fine using Clang for some architectures.  The
pixel phones have been using it for a few years now.

And if you wish to work on converting the kernel to use these
extensions, please go ahead, that would be a great research project!

greg k-h
