Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2011 15:45:46 -0800
From: Greg KH <greg@kroah.com>
Message-ID: <20111107234546.GA5835@kroah.com>
References: <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com>
 <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com>
 <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
 <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
 <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
 <20111107232750.GA4854@kroah.com>
 <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Theodore Tso <tytso@MIT.EDU>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 06:40:13PM -0500, Theodore Tso wrote:
> 
> On Nov 7, 2011, at 6:27 PM, Greg KH wrote:
> > 
> > So, what do we really need revoke() for these days?
> 
> As I mentioned at the kernel summit, I'd like revoke along with a
> formal notification from block devices that get ejected to the file
> system layer, and the file system should be able to call a VFS library
> function which revokes all open file descriptor on the ejected block
> device.  It would result in much cleaner handling at the file system
> level when a USB storage device gets pulled.

So you want revoke() on a block device to do what?  The same thing as
disconnecting it from the hardware level?

> > But that's getting away from the original topic here, sorry…
> 
> Yup.   But if revoke has come up, I'd like to remind folks that there
> are good uses of it besides just tty devices that receive hangup
> events.   Having the modem connection disappear and the USB device
> disappear isn't all that different from a conceptual point of view.

Oh, I forgot that this came up while we were drinking at the LinuxCon
Japan conference this year and we figured out that you could just use
the 'unbind' and 'bind' files in sysfs to disconnect and reconnect the
device from the driver from userspace which would simulate a revoke()
call on pretty much any type of char device we have today.

Sure, it's crude, and yes, it's the result of a lot of whisky, but even
now, it still seems like a nice hack if you really want and need this
from userspace :)

thanks,

greg k-h
