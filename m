Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Dec 2016 13:18:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161215211807.GA13393@kroah.com>
References: <20161214185000.GA3930@kroah.com>
 <20161214185052.GC4939@kroah.com>
 <20161214202952.GV1555@brightrain.aerifal.cx>
 <20161214205444.GA16183@kroah.com>
 <20161215175439.GA1172@kroah.com>
 <1481835061.3477.5.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1481835061.3477.5.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 3/4] Make static usermode helper
 binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 15, 2016 at 03:51:01PM -0500, Daniel Micay wrote:
> > To follow up on this, and after staring at too many outputs of the
> > compiler, I think what this really should be is:
> > 	static char const critical_overtemp_path[] =
> > "/sbin/critical_overtemp";
> > right?
> > 
> > That way both the variable, and the data, end up in read-only memory
> > from what I can tell.
> > 
> > But, if I do:
> > 	static char const char critical_overtemp_path[] =
> > "/sbin/critical_overtemp";
> > then sparse complains to me about:
> > 	warning: duplicate const
> > 
> > Is that just sparse being dense, or is the latter one really better
> > here?  It seems that both of the above put the data and variable into
> > the same segment (.rodata).
> > 
> > thanks,
> > 
> > greg k-h
> 
> Either 'char *const foo = "bar"' or 'const char *const foo = "bar" will
> also be a string constant in rodata with a pointer in rodata referring
> to them. Duplicate string constants get merged without any analysis as
> there's no guarantee of a unique address for the data itself since it's
> not a variable. 'const char foo[] = "bar"' goes into rodata too, but is
> the toolchain can't assume it can't safely merge strings + sizeof works
> but gcc/clang know how to optimize constant strlen anyway.

Thanks for the explanation.  I don't think we need to worry about
merging these strings, but I'll keep it in mind.

However, the "folklore" of the kernel was to never do:
	char *foo = "bar";
but instead do:
	char foo[] = "bar";
to save on the extra variable that the former creates.  Is that no
longer the case and we really should be using '*' to allow gcc to be
smarter about optimizations?

> The 'const' qualifier for pointers doesn't really do anything, it's when
> it's used on the variable (after the pointer) that it can do more than
> acting as a programming guide.

Many thanks for the explanations,

greg k-h
