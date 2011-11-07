Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2011 15:27:50 -0800
From: Greg KH <greg@kroah.com>
Message-ID: <20111107232750.GA4854@kroah.com>
References: <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros>
 <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com>
 <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com>
 <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
 <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
 <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 11:21:32PM +0000, Alan Cox wrote:
> > It's better than nothing, but it really isn't wonderful - because it's
> > really not just about audio. And revoke doesn't work universally.
> 
> BSD invented revoke but never implemented it universally. It turns out
> that this isn't a big problem. Right now we basically only have revoke
> for tty devices but we don't need it for that much more. Revoke on disk
> files and the like has simply never happened because its not a matter of
> revoke being universal so much as universal revoke being universally
> pointless.

I looked into implementing revoke() a while ago, and looked at how BSD
did it.  They really only implemented it for a very narrow range of
devices (tty only I think), which is not what we really want.

I thought people wanted it for all char and block devices, if this isn't
so, then it might be easier to implement than I thought.

So, what do we really need revoke() for these days?

But that's getting away from the original topic here, sorry...

greg k-h
