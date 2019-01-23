Date: Wed, 23 Jan 2019 11:18:02 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [Intel-gfx] [PATCH 1/3] treewide: Lift switch variables out of
 switches
Message-ID: <20190123191802.GB15311@bombadil.infradead.org>
References: <20190123110349.35882-1-keescook@chromium.org>
 <20190123110349.35882-2-keescook@chromium.org>
 <20190123115829.GA31385@kroah.com>
 <874l9z31c5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874l9z31c5.fsf@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, dev@openvswitch.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, intel-wired-lan@lists.osuosl.org, linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org, Laura Abbott <labbott@redhat.com>, linux-kbuild@vger.kernel.org, Alexander Popov <alex.popov@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 23, 2019 at 04:17:30PM +0200, Jani Nikula wrote:
> Can't have:
> 
> 	switch (i) {
> 		int j;
> 	case 0:
>         	/* ... */
> 	}
> 
> because it can't be turned into:
> 
> 	switch (i) {
> 		int j = 0; /* not valid C */
> 	case 0:
>         	/* ... */
> 	}
> 
> but can have e.g.:
> 
> 	switch (i) {
> 	case 0:
> 		{
> 			int j = 0;
> 	        	/* ... */
> 		}
> 	}
> 
> I think Kees' approach of moving such variable declarations to the
> enclosing block scope is better than adding another nesting block.

Another nesting level would be bad, but I think this is OK:

	switch (i) {
	case 0: {
		int j = 0;
        	/* ... */
	}
	case 1: {
		void *p = q;
		/* ... */
	}
	}

I can imagine Kees' patch might have a bad effect on stack consumption,
unless GCC can be relied on to be smart enough to notice the
non-overlapping liveness of the vriables and use the same stack slots
for both.
