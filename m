Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 17:48:31 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170117174831.GB367@leverpostej>
References: <20170113220256.GA57663@beast>
 <5879F762.32059.37092152@pageexec.freemail.hu>
 <20170116152425.GG5908@leverpostej>
 <587D1F55.2222.8A262A4@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <587D1F55.2222.8A262A4@pageexec.freemail.hu>
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 08:30:29PM +0100, PaX Team wrote:
> On 16 Jan 2017 at 15:24, Mark Rutland wrote:
> 
> > To me, it seems that the __user annotation can only be an indicator of
> > an issue by chance. We have structures with __user pointers in structs
> > that will never be copied to userspace, and conversely we have structs
> > that don't contain a __user field, but will be copied to userspace.
> > 
> > Maybe it happens that structs in more complex systems are more likely to
> > contain some __user pointer. Was that part of the rationale?
> 
> it's as i explained in an earlier email: we wanted to pattern match a
> specific bug situation and this was the easiest way (as you can see,
> the plugin's code is very simple, not much effort went into it).

Ok.

That being the case, (and given the relevant bug has now been fixed),
it's not clear to me what the value of this is today. i.e. given the
general case, is this preventing many leaks?

> > I wonder if there's any analysis we can do of data passing into
> > copy_to_user() and friends. I guess we can't follow the data flow across
> > compilation units, but we might be able to follow it well enough if we
> > added a new attribute that described whether data was to be copied to
> > userspace.
> 
> there're are all kinds of data flow analyses you can do within and even
> across translation units (summary info a'la size overflow hash tables or
> LTO). 

Sure.

> i never went into that direction because i think the security goal can
> be achieved without the performance impact of forced initialization.

Was there a particular technique you had in mind?

Thanks,
Mark.
