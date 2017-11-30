Message-ID: <1512053826.26048.8.camel@hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
Date: Thu, 30 Nov 2017 14:57:06 +0000
In-Reply-To: <CAJHCu1+yjSCReBGG4=K2Kx-iTjVxbSTqacM9bNVPNdg74pGoow@mail.gmail.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
	 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
	 <20171122165144.07aea7ac@alans-desktop>
	 <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com>
	 <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
	 <20171127002641.GA14743@openwall.com>
	 <CAJHCu1+yjSCReBGG4=K2Kx-iTjVxbSTqacM9bNVPNdg74pGoow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Solar Designer <solar@openwall.com>
Cc: David Laight <David.Laight@aculab.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W.
 Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-11-30 at 15:39 +0100, Salvatore Mesoraca wrote:
> 2017-11-27 1:26 GMT+01:00 Solar Designer <solar@openwall.com>:
> > On Fri, Nov 24, 2017 at 12:43:47PM +0100, Salvatore Mesoraca wrote:
> > > 2017-11-24 11:53 GMT+01:00 David Laight <David.Laight@aculab.com>
> > > :
> > > > From: Alan Cox
> > > > > Sent: 22 November 2017 16:52
> > > > > 
> > > > > On Wed, 22 Nov 2017 09:01:46 +0100 Salvatore Mesoraca <s.meso
> > > > > raca16@gmail.com> wrote:
> > > > > 
> > > > > > Disallows O_CREAT open missing the O_EXCL flag, in world or
> > > > > > group writable directories, even if the file doesn't exist
> > > > > > yet.
> > > > > > With few exceptions (e.g. shared lock files based on
> > > > > > flock())
> > 
> > Why would "shared lock files based on flock()" need O_CREAT without
> > O_EXCL?  Where specifically are they currently used that way?
> 
> I don't think that they *need* to act like this, but this is how
> util-linux's flock(1) currently works.
> And it doesn't seem an unreasonable behavior from their perspective,

I thought that too, specifically I reasoned that using O_EXCL would
defeat the purpose of the _shared_ flock(), wouldn't it?

Ian.
